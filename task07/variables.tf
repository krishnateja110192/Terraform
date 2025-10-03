variable "location" {
  description = "The region where the resources are located."
  type        = string
}

variable "project_name_base" {
  description = "The base string for generating all resource names (e.g., cmtr-ey1bz94q-mod7)."
  type        = string
}

variable "resource_group_id" {
  description = "The ID of the pre-created Resource Group to import."
  type        = string
}

variable "storage_account_id" {
  description = "The ID of the pre-created Storage Account to import."
  type        = string
}

variable "blob_filename" {
  description = "The filename (blob path) within the Storage Account to be served."
  type        = string
}

variable "cdn_profile_sku" {
  description = "The SKU for the Azure Front Door Profile."
  type        = string
}