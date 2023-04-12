variable "packer_resource_group" {
  description = "Name of the resource group where the packer image is"
  default     =  "Azuredevops"
  type        = string
}

variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  default     = "udacity-project1"
  type        = string
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default     = "East US"
}

variable "username" {
  description = "The login of the virtual machines."
  default     = "brem02"
  type        = string
}

variable "password" {
  description = "The password of the virtual machines."
  default     = "amelie11%$"
  type        = string
}

variable "number_vms" {
  description = "The number of VM to create."
  default     = 1
  type        = number
}
