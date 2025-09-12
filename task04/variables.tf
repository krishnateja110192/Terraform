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
variable "nsg_rule_http" {
  description = "Name of the NSG rule to allow HTTP traffic"
  type        = string
}

variable "nsg_rule_ssh" {
  description = "Name of the NSG rule to allow SSH traffic"
  type        = string
}
variable "nic_ip_config_name" {
  description = "Name of the IP configuration for the network interface"
  type        = string
}
variable "admin_username" {
  description = "Admin username for the virtual machine"
  type        = string
}