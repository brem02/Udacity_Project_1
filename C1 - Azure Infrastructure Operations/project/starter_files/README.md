# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.
This is a project related to Udacity Azure DevOps nanodegree. The goal is to deploy a policy and an image from a Packer template that will be used by Terraform.
This project will also deploy a set number of virtual machines (default is 3) behind a load balancer, and sets up all other resources that need to be deployed for those virtual machines such as network security groups. The VM's are only accessible through the internal network, Virtual Networks, Subnets and Virtual Nics.

### Getting Started
1. Clone this repository
2. Create your infrastructure as code
3. Update this README to reflect how someone would use your code.

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
Create a resource group:
------------------------
Either from the portal or the CLI, create a new resource group or the project.

Deploy the policy and assign it to the resource group.

Deploy the Packer image:
-------------------------
$ packer build server.json

Prepare with Terraform:
-----------------------
The terraform file creates the following resources:
resource group
virtual network
subnet
network security group limiting access
network interfaces
a public ip
load balancer
availability set for the virtual machines
Linux virtual machines (3 by default)
1 managed disk per instance

$ terraform init -> to prepare your directory for terraform

Modify:
The file terraform/vars.tf contains all the variables used inside the terraform/main.tf. If you want to personalize the code, it is likely, those values you want to modify first. The vars.tf file contains the variables for the resource group name, prefix for most resources, number of vm's to create, and location. If number of VM's and location are not specified they will be set default to 3 instances and Canada East, respectively. You will need to change the packer_resource_group variable if you used a different resource group name for the packer image.
Review the main.tf to confirm that it is creating the correct resources for your project.

$ terraform plan -out solution.plan  --> to show the changes terraform will be making

$ terraform apply "solution.plan"  --> Deploy with Terraform and apply these changes:

$ terraform destroy  --> If you no longer need the resources destroy the infrastructure with this command in order to remove all the ressources


### Output
The following will be the output by terraform if you have executed the terraform plan command and the same output will be generated when using the terraform apply command:

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_availability_set.main will be created
  + resource "azurerm_availability_set" "main" {
      + id                           = (known after apply)
      + location                     = "westeurope"
      + managed                      = true
      + name                         = "udacity-project1-aset"
      + platform_fault_domain_count  = 3
      + platform_update_domain_count = 5
      + resource_group_name          = "udacity-project1-rg"
      + tags                         = {
          + "environment" = "development"
          + "project"     = "udacity1"
        }
    }

  # azurerm_lb.main will be created
  + resource "azurerm_lb" "main" {
      + id                   = (known after apply)
      + location             = "westeurope"
      + name                 = "udacity-project1-lb"
      + private_ip_address   = (known after apply)
      + private_ip_addresses = (known after apply)
      + resource_group_name  = "udacity-project1-rg"
      + sku                  = "Basic"
      + sku_tier             = "Regional"

      + frontend_ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + id                                                 = (known after apply)
          + inbound_nat_rules                                  = (known after apply)
          + load_balancer_rules                                = (known after apply)
          + name                                               = "PublicIPAddress"
          + outbound_rules                                     = (known after apply)
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = (known after apply)
          + private_ip_address_version                         = (known after apply)
          + public_ip_address_id                               = (known after apply)
          + public_ip_prefix_id                                = (known after apply)
          + subnet_id                                          = (known after apply)
        }
    }

  # azurerm_lb_backend_address_pool.main will be created
  + resource "azurerm_lb_backend_address_pool" "main" {
      + backend_ip_configurations = (known after apply)
      + id                        = (known after apply)
      + load_balancing_rules      = (known after apply)
      + loadbalancer_id           = (known after apply)
      + name                      = "udacity-project1-lb-backend-address-pool"
      + outbound_rules            = (known after apply)
    }

  # azurerm_linux_virtual_machine.main[0] will be created
  + resource "azurerm_linux_virtual_machine" "main" {
      + admin_password                  = (sensitive value)
      + admin_username                  = "brem02"
      + allow_extension_operations      = true
      + availability_set_id             = (known after apply)
      + computer_name                   = (known after apply)
      + disable_password_authentication = false
      + extensions_time_budget          = "PT1H30M"
      + id                              = (known after apply)
      + location                        = "westeurope"
      + max_bid_price                   = -1
      + name                            = "udacity-project1-vm-0"
      + network_interface_ids           = (known after apply)
      + patch_mode                      = "ImageDefault"
      + platform_fault_domain           = -1
      + priority                        = "Regular"
      + private_ip_address              = (known after apply)
      + private_ip_addresses            = (known after apply)
      + provision_vm_agent              = true
      + public_ip_address               = (known after apply)
      + public_ip_addresses             = (known after apply)
      + resource_group_name             = "udacity-project1-rg"
      + size                            = "Standard_B1ls"
      + source_image_id                 = "/subscriptions/e7a256dc-769a-421c-9f8e-e283ed3cbefa/resourceGroups/Azuredevops/providers/Microsoft.Compute/images/myPackerImage"
      + tags                            = {
          + "environment" = "development"
          + "project"     = "udacity1"
        }
      + virtual_machine_id              = (known after apply)

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = 1
          + name                      = (known after apply)
          + storage_account_type      = "Standard_LRS"
          + write_accelerator_enabled = false
        }

      + termination_notification {
          + enabled = (known after apply)
          + timeout = (known after apply)
        }
    }

  # azurerm_linux_virtual_machine.main[1] will be created
  + resource "azurerm_linux_virtual_machine" "main" {
      + admin_password                  = (sensitive value)
      + admin_username                  = "brem02"
      + allow_extension_operations      = true
      + availability_set_id             = (known after apply)
      + computer_name                   = (known after apply)
      + disable_password_authentication = false
      + extensions_time_budget          = "PT1H30M"
      + id                              = (known after apply)
      + location                        = "westeurope"
      + max_bid_price                   = -1
      + name                            = "udacity-project1-vm-1"
      + network_interface_ids           = (known after apply)
      + patch_mode                      = "ImageDefault"
      + platform_fault_domain           = -1
      + priority                        = "Regular"
      + private_ip_address              = (known after apply)
      + private_ip_addresses            = (known after apply)
      + provision_vm_agent              = true
      + public_ip_address               = (known after apply)
      + public_ip_addresses             = (known after apply)
      + resource_group_name             = "udacity-project1-rg"
      + size                            = "Standard_B1ls"
      + source_image_id                 = "/subscriptions/e7a256dc-769a-421c-9f8e-e283ed3cbefa/resourceGroups/Azuredevops/providers/Microsoft.Compute/images/myPackerImage"
      + tags                            = {
          + "environment" = "development"
          + "project"     = "udacity1"
        }
      + virtual_machine_id              = (known after apply)

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = 1
          + name                      = (known after apply)
          + storage_account_type      = "Standard_LRS"
          + write_accelerator_enabled = false
        }

      + termination_notification {
          + enabled = (known after apply)
          + timeout = (known after apply)
        }
    }

  # azurerm_linux_virtual_machine.main[2] will be created
  + resource "azurerm_linux_virtual_machine" "main" {
      + admin_password                  = (sensitive value)
      + admin_username                  = "brem02"
      + allow_extension_operations      = true
      + availability_set_id             = (known after apply)
      + computer_name                   = (known after apply)
      + disable_password_authentication = false
      + extensions_time_budget          = "PT1H30M"
      + id                              = (known after apply)
      + location                        = "westeurope"
      + max_bid_price                   = -1
      + name                            = "udacity-project1-vm-2"
      + network_interface_ids           = (known after apply)
      + patch_mode                      = "ImageDefault"
      + platform_fault_domain           = -1
     + priority                        = "Regular"
      + private_ip_address              = (known after apply)
      + private_ip_addresses            = (known after apply)
      + provision_vm_agent              = true
      + public_ip_address               = (known after apply)
      + public_ip_addresses             = (known after apply)
      + resource_group_name             = "udacity-project1-rg"
      + size                            = "Standard_B1ls"
      + source_image_id                 = "/subscriptions/e7a256dc-769a-421c-9f8e-e283ed3cbefa/resourceGroups/Azuredevops/providers/Microsoft.Compute/images/myPackerImage"
      + tags                            = {
          + "environment" = "development"
          + "project"     = "udacity1"
        }
      + virtual_machine_id              = (known after apply)

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = 1
          + name                      = (known after apply)
          + storage_account_type      = "Standard_LRS"
          + write_accelerator_enabled = false
        }

      + termination_notification {
          + enabled = (known after apply)
          + timeout = (known after apply)
        }
    }

  # azurerm_network_interface.main will be created
  + resource "azurerm_network_interface" "main" {
      + applied_dns_servers           = (known after apply)
      + dns_servers                   = (known after apply)
      + enable_accelerated_networking = false
      + enable_ip_forwarding          = false
      + id                            = (known after apply)
      + internal_dns_name_label       = (known after apply)
      + internal_domain_name_suffix   = (known after apply)
      + location                      = "westeurope"
      + mac_address                   = (known after apply)
      + name                          = "udacity-project1-nic"
      + private_ip_address            = (known after apply)
      + private_ip_addresses          = (known after apply)
      + resource_group_name           = "udacity-project1-rg"
      + tags                          = {
          + "environment" = "development"
          + "project"     = "udacity1"
        }
      + virtual_machine_id            = (known after apply)

      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "internal"
          + primary                                            = (known after apply)
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = "Dynamic"
          + private_ip_address_version                         = "IPv4"
          + subnet_id                                          = (known after apply)
        }
    }

  # azurerm_network_interface_backend_address_pool_association.main will be created
  + resource "azurerm_network_interface_backend_address_pool_association" "main" {
      + backend_address_pool_id = (known after apply)
      + id                      = (known after apply)
      + ip_configuration_name   = "internal"
      + network_interface_id    = (known after apply)
    }

  # azurerm_network_security_group.main will be created
  + resource "azurerm_network_security_group" "main" {
      + id                  = (known after apply)
      + location            = "westeurope"
      + name                = "main"
      + resource_group_name = "udacity-project1-rg"
      + security_rule       = (known after apply)
      + tags                = {
          + "environment" = "development"
          + "project"     = "udacity1"
        }
    }

 # azurerm_network_security_rule.rule1 will be created
  + resource "azurerm_network_security_rule" "rule1" {
      + access                      = "Deny"
      + description                 = "This rule with low priority denies all the inbound traffic."
      + destination_address_prefix  = "*"
      + destination_port_range      = "*"
      + direction                   = "Inbound"
      + id                          = (known after apply)
      + name                        = "DenyAllInbound"
      + network_security_group_name = "main"
      + priority                    = 100
      + protocol                    = "*"
      + resource_group_name         = "udacity-project1-rg"
      + source_address_prefix       = "*"
      + source_port_range           = "*"
    }

  # azurerm_network_security_rule.rule2 will be created
  + resource "azurerm_network_security_rule" "rule2" {
      + access                      = "Allow"
      + description                 = "This rule allows the inbound traffic inside the same virtual network."
      + destination_address_prefix  = "VirtualNetwork"
      + destination_port_ranges     = [
          + "10.0.0.0/22",
        ]
      + direction                   = "Inbound"
      + id                          = (known after apply)
      + name                        = "AllowInboundInsideVN"
      + network_security_group_name = "main"
      + priority                    = 101
      + protocol                    = "*"
      + resource_group_name         = "udacity-project1-rg"
      + source_address_prefix       = "VirtualNetwork"
      + source_port_ranges          = [
          + "10.0.0.0/22",
        ]
    }

  # azurerm_network_security_rule.rule3 will be created
  + resource "azurerm_network_security_rule" "rule3" {
      + access                      = "Allow"
      + description                 = "This rule allows the outbound traffic inside the same virtual network."
      + destination_address_prefix  = "VirtualNetwork"
      + destination_port_ranges     = [
          + "10.0.0.0/22",
        ]
      + direction                   = "Outbound"
      + id                          = (known after apply)
      + name                        = "AllowOutboundInsideVN"
      + network_security_group_name = "main"
      + priority                    = 102
      + protocol                    = "*"
      + resource_group_name         = "udacity-project1-rg"
      + source_address_prefix       = "VirtualNetwork"
      + source_port_ranges          = [
          + "10.0.0.0/22",
        ]
    }

  # azurerm_network_security_rule.rule4 will be created
  + resource "azurerm_network_security_rule" "rule4" {
      + access                      = "Allow"
      + description                 = "This rule allows the HTTP traffic from the load balancer."
      + destination_address_prefix  = "VirtualNetwork"
      + destination_port_ranges     = [
          + "10.0.0.0/22",
        ]
      + direction                   = "Inbound"
      + id                          = (known after apply)
      + name                        = "AllowHTTPFromLB"
      + network_security_group_name = "main"
      + priority                    = 103
      + protocol                    = "Tcp"
      + resource_group_name         = "udacity-project1-rg"
      + source_address_prefix       = "AzureLoadBalancer"
      + source_port_ranges          = [
          + "10.0.0.0/22",
        ]
    }

  # azurerm_public_ip.main will be created
  + resource "azurerm_public_ip" "main" {
      + allocation_method       = "Static"
      + fqdn                    = (known after apply)
      + id                      = (known after apply)
      + idle_timeout_in_minutes = 4
      + ip_address              = (known after apply)
      + ip_version              = "IPv4"
      + location                = "westeurope"
      + name                    = "udacity-project1-public-ip"
      + resource_group_name     = "udacity-project1-rg"
      + sku                     = "Basic"
      + sku_tier                = "Regional"
      + tags                    = {
          + "environment" = "development"
          + "project"     = "udacity1"
        }
    }

  # azurerm_resource_group.main will be created
  + resource "azurerm_resource_group" "main" {
      + id       = (known after apply)
      + location = "westeurope"
      + name     = "udacity-project1-rg"
    }

  # azurerm_subnet.internal will be created
  + resource "azurerm_subnet" "internal" {
      + address_prefixes                               = [
          + "10.0.2.0/24",
        ]
      + enforce_private_link_endpoint_network_policies = false
      + enforce_private_link_service_network_policies  = false
      + id                                             = (known after apply)
      + name                                           = "internal"
      + resource_group_name                            = "udacity-project1-rg"
      + virtual_network_name                           = "udacity-project1-network"
    }

  # azurerm_virtual_network.main will be created
  + resource "azurerm_virtual_network" "main" {
      + address_space       = [
          + "10.0.0.0/22",
        ]
      + dns_servers         = (known after apply)
      + guid                = (known after apply)
      + id                  = (known after apply)
      + location            = "westeurope"
      + name                = "udacity-project1-network"
      + resource_group_name = "udacity-project1-rg"
      + subnet              = (known after apply)
      + tags                = {
          + "environment" = "development"
          + "project"     = "udacity1"
        }
    }

Plan: 17 to add, 0 to change, 0 to destroy.

