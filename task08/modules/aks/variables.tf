variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "aks_name" { type = string }
variable "tags" { type = map(string) }
variable "default_node_pool_name" { type = string }
variable "default_node_pool_count" { type = number }
variable "default_node_pool_vm_size" { type = string }
variable "default_node_pool_os_disk_type" { type = string }
variable "acr_id" { type = string }
variable "key_vault_id" { type = string }
variable "default_node_pool_os_disk_size_gb" {
  type        = number
  description = "OS disk size (GiB) for the default node pool; must fit VM local disk if Ephemeral."
  default     = 64
}