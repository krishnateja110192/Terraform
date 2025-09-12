variable "location" {
  description = "Azure region for all resources"
  type        = string
}

variable "vm_password" {
  description = "Admin password for the virtual machine"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

# Define variables for all resource names
variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}
variable "vnet_name" {
  type        = string
  description = "Name of the virtual network"
}
variable "subnet_name" {
  type        = string
  description = "Name of the subnet"
}
variable "nsg_name" {
  type        = string
  description = "Name of the network security group"
}
variable "nic_name" {
  type        = string
  description = "Name of the network interface"
}
variable "pip_name" {
  type        = string
  description = "Name of the public IP"
}
variable "dns_label" {
  type        = string
  description = "DNS label for the public IP"
}
variable "vm_name" {
  type        = string
  description = "Name of the virtual machine"
}
variable "vm_sku" {
  type        = string
  description = "SKU for the virtual machine"
}
variable "vm_os_version" {
  type        = string
  description = "OS version for the virtual machine"
}
