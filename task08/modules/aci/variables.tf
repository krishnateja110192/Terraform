variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Container Instance."
}

variable "location" {
  type        = string
  description = "The Azure region where the Container Instance will be deployed."
}

variable "aci_name" {
  type        = string
  description = "The unique name for the Azure Container Instance (ACI)."
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the Azure Container Instance resource."
}

variable "container_image" {
  type        = string
  description = "The Docker image name and tag to use for the container (e.g., 'myregistry.azurecr.io/app:v1')."
}

variable "acr_server" {
  type        = string
  description = "The login server for the Azure Container Registry (ACR) (e.g., 'myregistry.azurecr.io')."
}

variable "acr_username" {
  type        = string
  description = "The username (Service Principal ID) for accessing the Azure Container Registry."
}

variable "acr_password" {
  type        = string
  description = "The password (Service Principal Secret) for accessing the Azure Container Registry."
  sensitive   = true
}

variable "key_vault_id" {
  type        = string
  description = "The resource ID of the Azure Key Vault, used for accessing secrets."
}

variable "redis_hostname_secret_name" {
  type        = string
  description = "The name of the secret in Azure Key Vault that holds the Redis cache hostname."
}

variable "redis_primary_key_secret_name" {
  type        = string
  description = "The name of the secret in Azure Key Vault that holds the Redis cache primary key."
}

variable "container_port" {
  type        = number
  description = "The port exposed by the container within the ACI."
}

variable "creator" {
  type        = string
  description = "The identifier of the user or system creating the resource, often used for tagging or tracking."
}

variable "redis_port" {
  type        = string
  description = "The port used to connect to the Redis Cache (e.g., '6379' for non-SSL, '6380' for SSL)."
}

variable "redis_ssl_mode" {
  type        = string
  description = "Specifies whether SSL should be used when connecting to Redis (e.g., 'true' or 'false')."
}