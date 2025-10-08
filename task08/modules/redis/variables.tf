variable "redis_name" {
  type        = string
  description = "The name for the Azure Redis Cache instance."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Redis Cache."
}

variable "location" {
  type        = string
  description = "The Azure region where the Redis Cache and related resources should be created."
}

variable "capacity" {
  type        = number
  description = "The size of the Redis Cache. Must be between 0 and 6 for C family, or between 0 and 9 for P family."
}

variable "sku_family" {
  type        = string
  description = "The SKU family for the Redis Cache. Possible values are 'C' (Basic/Standard) or 'P' (Premium)."
}

variable "sku_name" {
  type        = string
  description = "The SKU name for the Redis Cache. Possible values are 'Basic', 'Standard', or 'Premium'."
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the Azure Redis Cache resource."
}

variable "key_vault_id" {
  type        = string
  description = "The ID of the Azure Key Vault where Redis connection details will be stored."
}

variable "redis_primary_key_secret_name" {
  type        = string
  description = "The name of the secret in Azure Key Vault to store the Redis primary access key."
}

variable "redis_hostname_secret_name" {
  type        = string
  description = "The name of the secret in Azure Key Vault to store the Redis host name/URL."
}