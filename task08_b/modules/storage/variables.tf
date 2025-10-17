#############################################
# Storage module - variables.tf (corrected)
#############################################

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The location of the resources."
  type        = string
}

variable "storage_account_name" {
  description = "The globally-unique name of the Storage Account."
  type        = string
}

variable "replication_type" {
  description = "Storage account replication type (e.g., LRS, GRS, RAGRS, ZRS)."
  type        = string
  default     = "LRS"
}

variable "container_name" {
  description = "The name of the storage container."
  type        = string
}

variable "container_access_type" {
  description = "Container access level: private | blob | container."
  type        = string
  default     = "private"
}

variable "app_content_dir" {
  description = "Path to the application content directory to archive."
  type        = string
}

variable "archive_file_name" {
  description = "The file name for the generated archive and blob (e.g., app.tgz)."
  type        = string
  default     = "app.tgz"
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}
