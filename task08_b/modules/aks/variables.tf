variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The Azure region."
  type        = string
}

variable "aks_name" {
  description = "The name of the AKS cluster."
  type        = string
}

variable "default_pool_name" {
  description = "The name of the default node pool."
  type        = string
}

variable "node_count" {
  description = "The initial number of nodes for the default node pool."
  type        = number
}

variable "node_size" {
  description = "The size of the nodes in the default node pool."
  type        = string
}

variable "os_disk_type" {
  description = "The OS disk type for the default node pool."
  type        = string
}

variable "acr_login_server" {
  description = "The ACR login server name."
  type        = string
}

variable "acr_resource_id" {
  description = "The ID of the Azure Container Registry."
  type        = string
}

variable "keyvault_id" {
  description = "The ID of the Azure Key Vault."
  type        = string
}

variable "keyvault_tenant_id" {
  description = "The Tenant ID of the Key Vault."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the AKS cluster."
  type        = map(string)
}

variable "os_disk_size_gb" {
  type        = number
  description = "OS disk size (GiB) for the default node pool; must fit VM local disk if Ephemeral."
  default     = 64
}

