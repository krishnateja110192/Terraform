variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The Azure region."
  type        = string
}

variable "key_vault_name" {
  description = "The name of the Key Vault."
  type        = string
}

variable "sku_name" {
  description = "The SKU for the Key Vault."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the Key Vault resource."
  type        = map(string)
}