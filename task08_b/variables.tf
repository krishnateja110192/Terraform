variable "name_prefix" {
  description = "Prefix for all resource names."
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resources."
  type        = map(string)
}

variable "acr_sku" {
  description = "SKU for Azure Container Registry."
  type        = string
  default     = "Basic"
}

variable "acr_app_image_name" {
  description = "Name for the Docker application image."
  type        = string
  default     = "cmtr-ey1bz94q-mod8b-app"
}

variable "redis_aci_image" {
  description = "Docker image for Redis on ACI."
  type        = string
  default     = "mcr.microsoft.com/cbl-mariner/base/redis:6.2-cm2.0"
}

variable "redis_aci_sku" {
  description = "The SKU for the Redis ACI container group."
  type        = string
  default     = "Standard"
}

variable "sa_replication_type" {
  description = "The replication type for the Storage Account."
  type        = string
  default     = "LRS"
}

variable "sa_container_access_type" {
  description = "The access type for the Storage Account container."
  type        = string
  default     = "private"
}

variable "aks_default_node_pool_count" {
  description = "The initial number of nodes for the default node pool."
  type        = number
  default     = 1
}

variable "aks_default_node_size" {
  description = "The size of the nodes in the default node pool."
  type        = string
  default     = "Standard_D2ads_v6"
}

variable "aks_default_node_os_disk_type" {
  description = "The OS disk type for the default node pool."
  type        = string
  default     = "Ephemeral"
}

variable "aks_default_node_os_disk_size_gb" {
  type        = number
  description = "OS disk size (GiB) for the default node pool; must fit VM local disk if Ephemeral."
  default     = 64
}

variable "keyvault_sku_name" {
  description = "The SKU for the Azure Key Vault."
  type        = string
  default     = "standard"
}

variable "keyvault_redis_password_secret_name" {
  description = "The name of the secret for Redis password."
  type        = string
  default     = "redis-password"
}

variable "keyvault_redis_hostname_secret_name" {
  description = "The name of the secret for Redis hostname."
  type        = string
  default     = "redis-hostname"
}