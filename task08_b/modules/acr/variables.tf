variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The Azure region."
  type        = string
}

variable "acr_name" {
  description = "The name of the Azure Container Registry."
  type        = string
}

variable "sku" {
  description = "The SKU for the Container Registry."
  type        = string
}

variable "app_image_name" {
  description = "The name of the Docker image."
  type        = string
}

variable "image_tag" {
  description = "The tag for the Docker image."
  type        = string
}

variable "storage_account_blob_url" {
  description = "The full URL of the application archive blob."
  type        = string
}

variable "storage_account_container_sas" {
  description = "The SAS token for the application archive blob."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the ACR."
  type        = map(string)
}

# variables.tf
variable "cron_schedule" {
  description = "CRON schedule for the ACR timer trigger (UTC). Example: '15 0 * * *' for 00:15 UTC daily."
  type        = string
  default     = "15 0 * * *"
}