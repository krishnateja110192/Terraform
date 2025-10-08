variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the AKS cluster will be created."
}

variable "location" {
  type        = string
  description = "The Azure region where the AKS cluster and related resources will be deployed."
}

variable "aks_name" {
  type        = string
  description = "The unique name for the Azure Kubernetes Service (AKS) cluster."
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the AKS cluster resource."
}

variable "default_node_pool_name" {
  type        = string
  description = "The name for the default node pool within the AKS cluster."
}

variable "default_node_pool_count" {
  type        = number
  description = "The initial number of nodes in the default node pool."
}

variable "default_node_pool_vm_size" {
  type        = string
  description = "The size of the Virtual Machine (VM) to use for the nodes in the default node pool (e.g., 'Standard_DS2_v2')."
}

variable "default_node_pool_os_disk_type" {
  type        = string
  description = "The OS disk type to use for the default node pool. Possible values are 'Managed' or 'Ephemeral'."
}

variable "acr_id" {
  type        = string
  description = "The resource ID of the Azure Container Registry (ACR) to be attached to the AKS cluster for image pulling."
}

variable "key_vault_id" {
  type        = string
  description = "The resource ID of the Azure Key Vault to be integrated with the AKS cluster, often used for secrets access."
}

variable "default_node_pool_os_disk_size_gb" {
  type        = number
  description = "OS disk size (GiB) for the default node pool; must fit VM local disk if Ephemeral."
  default     = 64
}