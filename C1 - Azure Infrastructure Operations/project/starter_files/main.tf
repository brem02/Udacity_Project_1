# Specify the version of the AzureRM Provider to use
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=3.0.1"
    }
  }
}

provider "azurerm" {
  # The AzureRM Provider supports authenticating using via the Azure CLI, a Managed Identity
  # and a Service Principal. More information on the authentication methods supported by
  # the AzureRM Provider can be found here:
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#authenticating-to-azure

  # The features block allows changing the behaviour of the Azure Provider, more
  # information can be found here:
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/features-block
  features {}
}

# get the image that was created by the packer script
data "azurerm_image" "web" {
  name                = "myPackerImage"
  resource_group_name = var.packer_resource_group
}

# Create the resource group
data "azurerm_resource_group" "main" {
  name     = "Azuredevops"
  #location = var.location
}

# create a virtual network within the resource group
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/24"]
  #location            = data.azurerm_resource_group.main.location
  location            = var.location
  resource_group_name = data.azurerm_resource_group.main.name

  tags = {
    project = "udacity1"
    environment = "development"
  }
}

# Create the subnet within virtual network
resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.0.0/28"]
}

# Create the network security group
resource "azurerm_network_security_group" "main" {
  name                = "main"
  #location            = data.azurerm_resource_group.main.location
  location            = var.location
  resource_group_name = data.azurerm_resource_group.main.name

  tags = {
    project = "udacity1"
    environment = "development"
  }
}

# Create security rules
resource "azurerm_network_security_rule" "rule1" {
    name                         = "DenyAllInbound"
    description                  = "This rule with low priority denies all the inbound traffic."
    priority                     = 100
    direction                    = "Inbound"
    access                       = "Deny"
    protocol                     = "*"
    source_port_range            = "*"
    destination_port_range       = "*"
    source_address_prefix        = "*"
    destination_address_prefix   = "*"
    resource_group_name          = data.azurerm_resource_group.main.name
    network_security_group_name  = azurerm_network_security_group.main.name
}

resource "azurerm_network_security_rule" "rule2" {
    name                         = "AllowInboundInsideVN"
    description                  = "This rule allows the inbound traffic inside the same virtual network."
    priority                     = 101
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "*"
    source_port_ranges           = ["30315-30317"]
    destination_port_ranges      = ["30315-30317"]
    source_address_prefix        = "VirtualNetwork"
    destination_address_prefix   = "VirtualNetwork"
    resource_group_name          = data.azurerm_resource_group.main.name
    network_security_group_name  = azurerm_network_security_group.main.name
}

resource "azurerm_network_security_rule" "rule3" {
    name                         = "AllowOutboundInsideVN"
    description                  = "This rule allows the outbound traffic inside the same virtual network."
    priority                     = 102
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "*"
    source_port_ranges           = ["30315-30317"]
    destination_port_ranges      = ["30315-30317"]
    source_address_prefix        = "VirtualNetwork"
    destination_address_prefix   = "VirtualNetwork"
    resource_group_name          = data.azurerm_resource_group.main.name
    network_security_group_name  = azurerm_network_security_group.main.name
}

resource "azurerm_network_security_rule" "rule4" {
    name                         = "AllowHTTPFromLB"
    description                  = "This rule allows the HTTP traffic from the load balancer."
    priority                     = 103
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_ranges           = ["30315-30317"]
    destination_port_ranges      = ["30315-30317"]
    source_address_prefix        = "AzureLoadBalancer"
    destination_address_prefix   = "VirtualNetwork"
    resource_group_name          = data.azurerm_resource_group.main.name
    network_security_group_name  = azurerm_network_security_group.main.name
}

# Create network interfaces
resource "azurerm_network_interface" "main" {
  count               = var.number_vms
  name                = "${var.prefix}-${count.index}-nic"
  resource_group_name = data.azurerm_resource_group.main.name
  #location            = data.azurerm_resource_group.main.location
  location                        = var.location
  
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    project = "udacity1"
    environment = "development"
  }
}

# Create public IP
resource "azurerm_public_ip" "main" {
  name                = "${var.prefix}-public-ip"
  resource_group_name = data.azurerm_resource_group.main.name
  #location            = data.azurerm_resource_group.main.location
  location                        = var.location
  allocation_method   = "Static"

  tags = {
    project = "udacity1"
    environment = "development"
  }
}

# Create load balancer
resource "azurerm_lb" "main" {
  name                = "${var.prefix}-lb"
  #location            = data.azurerm_resource_group.main.location
  location                        = var.location
  resource_group_name = data.azurerm_resource_group.main.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.main.id
  }
}

# The load balancer will use this backend pool
resource "azurerm_lb_backend_address_pool" "main" {
  #resource_group_name = data.azurerm_resource_group.main.name
  loadbalancer_id     = azurerm_lb.main.id
  name                = "${var.prefix}-lb-backend-address-pool"
}

# Associate the LB with the backend address pool
resource "azurerm_network_interface_backend_address_pool_association" "main" {
  count                   = var.number_vms
  network_interface_id    = azurerm_network_interface.main[count.index].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.main.id
}

# Create virtual machine availability set
resource "azurerm_availability_set" "main" {
  name                = "${var.prefix}-aset"
  #location            = data.azurerm_resource_group.main.location
  location                        = var.location
  resource_group_name = data.azurerm_resource_group.main.name

  tags = {
    project = "udacity1"
    environment = "development"
  }
}

# Create the virtual machines
resource "azurerm_linux_virtual_machine" "main" {
  count                           = var.number_vms
  name                            = "${var.prefix}-vm-${count.index}"
  resource_group_name             = data.azurerm_resource_group.main.name
  #location                        = data.azurerm_resource_group.main.location
  location                        = var.location
  size                            = "Standard_B1s"
  admin_username                  = "${var.username}"
  admin_password                  = "${var.password}"
  disable_password_authentication = false
  network_interface_ids = [element(azurerm_network_interface.main.*.id, count.index)]
  availability_set_id = azurerm_availability_set.main.id

  source_image_id = data.azurerm_image.web.id

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
    #create_option        = "Empty"
    #disk_size_gb         = "1"
  }

  tags = {
    project = "udacity1"
    environment = "development"
  }
}

#create a virtual disk for each VM created.
resource "azurerm_managed_disk" "main" {
  count                           = var.number_vms
  name                            = "data-disk-${count.index}"
  #location                        = data.azurerm_resource_group.main.location
  location                        = var.location
  resource_group_name             = data.azurerm_resource_group.main.name
  storage_account_type            = "Standard_LRS"
  create_option                   = "Empty"
  disk_size_gb                    = 1
}

resource "azurerm_virtual_machine_data_disk_attachment" "main" {
  count              = var.number_vms
  managed_disk_id    = azurerm_managed_disk.main.*.id[count.index]
  virtual_machine_id = azurerm_linux_virtual_machine.main.*.id[count.index]
  lun                = 10 * count.index
  caching            = "ReadWrite"
}
