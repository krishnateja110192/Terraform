variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The Azure region."
  type        = string
}

variable "aci_name" {
  description = "The name of the Azure Container Instance."
  type        = string
}

variable "redis_image" {
  description = "The Docker image for Redis."
  type        = string
}

variable "redis_aci_sku" {
  description = "The SKU for the Redis ACI container group."
  type        = string
}

variable "keyvault_id" {
  description = "The ID of the Azure Key Vault."
  type        = string
}

variable "redis_password_secret_name" {
  description = "The name of the secret for Redis password."
  type        = string
}

variable "redis_hostname_secret_name" {
  description = "The name of the secret for Redis hostname."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the ACI."
  type        = map(string)
}

# modules/aci_redis/variables.tf