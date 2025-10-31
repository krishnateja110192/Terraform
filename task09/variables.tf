# task09/variables.tf

variable "location" {
  description = "The Azure region to deploy resources"
  type        = string
}

variable "resource_group_name" {
  description = "Existing Resource Group name"
  type        = string

}

variable "vnet_name" {
  description = "Existing Virtual Network name"
  type        = string

}

variable "vnet_address_space" {
  description = "Existing Virtual Network Address Space"
  type        = string

}

variable "aks_snet_name" {
  description = "Existing Subnet name (AKS Cluster subnet)"
  type        = string

}

variable "aks_snet_address_prefix" {
  description = "Existing Subnet Address Space (AKS Cluster subnet)"
  type        = string

}

variable "firewall_pip_name" {
  description = "Firewall Public IP name"
  type        = string

}

variable "aks_loadbalancer_ip" {
  description = "AKS load-balancer Public IP"
  type        = string

}