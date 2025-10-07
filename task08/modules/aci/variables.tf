variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "aci_name" { type = string }
variable "tags" { type = map(string) }
variable "container_image" { type = string }
variable "acr_server" { type = string }
variable "acr_username" { type = string }
variable "acr_password" {
  type      = string
  sensitive = true
}
variable "key_vault_id" { type = string }
variable "redis_hostname_secret_name" { type = string }
variable "redis_primary_key_secret_name" { type = string }
variable "container_port" { type = number }
variable "creator" { type = string }
variable "redis_port" { type = string }
variable "redis_ssl_mode" { type = string }