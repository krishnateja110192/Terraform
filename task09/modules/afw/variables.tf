
variable "resource_group_name" {
  description = "The name of the existing Resource Group"
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources"
  type        = string
}

variable "vnet_name" {
  description = "The name of the existing Virtual Network"
  type        = string
}

variable "vnet_address_space" {
  description = "The address space of the existing Virtual Network"
  type        = string
}

variable "aks_snet_name" {
  description = "The name of the existing AKS cluster subnet"
  type        = string
}

variable "naming_prefix" {
  description = "The prefix for all resources, based on the task parameters"
  type        = string
}

variable "aks_loadbalancer_ip" {
  description = "The public IP address of the AKS Load Balancer"
  type        = string
}

variable "firewall_pip_name" {
  description = "The name of the existing Public IP for the Firewall"
  type        = string
}

variable "aks_snet_address_prefix" {
  description = "The address prefix of the existing AKS cluster subnet"
  type        = string
}