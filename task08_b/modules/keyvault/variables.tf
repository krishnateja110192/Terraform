variable "resource_group_name" {
  description = "The name of the resource group in which to create the Key Vault."
  type        = string
}

variable "location" {
  description = "The Azure region where the Key Vault should be created."
  type        = string
}

variable "tenant_id" {
  description = "The Azure Active Directory Tenant ID that should be used for the Key Vault."
  type        = string
}

variable "current_user_object_id" {
  description = "The object ID of the current user (for access policy)."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the Key Vault."
  type        = map(string)
}

variable "sku_name" {
  description = "The Name of the SKU used for the Key Vault."
  type        = string
}

variable "keyvault_name" {
  description = "The name of the Key Vault."
  type        = string
}