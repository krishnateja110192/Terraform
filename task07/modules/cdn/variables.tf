variable "resource_group_name" {
  description = "The name of the Resource Group where the CDN resources will be deployed."
  type        = string
}

variable "location" {
  description = "The location where the CDN resources will be deployed."
  type        = string
}

variable "cdn_profile_name" {
  description = "The name for the Azure Front Door Profile."
  type        = string
}

variable "cdn_profile_sku" {
  description = "The SKU for the Azure Front Door Profile."
  type        = string
}

variable "cdn_endpoint_name" {
  description = "The name for the Azure Front Door Endpoint."
  type        = string
}

variable "cdn_origin_group_name" {
  description = "The name for the Azure Front Door Origin Group."
  type        = string
}

variable "cdn_origin_name" {
  description = "The name for the Azure Front Door Origin."
  type        = string
}

variable "cdn_route_name" {
  description = "The name for the Azure Front Door Route."
  type        = string
}

variable "storage_account_host" {
  description = "The primary blob service host of the Storage Account (e.g., <sa_name>.blob.core.windows.net)."
  type        = string
}

variable "blob_path" {
  description = "The path to the blob file to be served (e.g., /blob.txt)."
  type        = string
}