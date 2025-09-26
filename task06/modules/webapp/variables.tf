variable "location" {
  description = "The Azure Region."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "asp_name" {
  description = "The name of the App Service Plan."
  type        = string
}

variable "asp_sku" {
  description = "The SKU for the App Service Plan (e.g., P0v3)."
  type        = string
}

variable "os_type" {
  description = "The operating system type for the App Service Plan (e.g., Linux or Windows)."
  type        = string
}

variable "app_name" {
  description = "The name of the Web Application."
  type        = string
}

variable "dotnet_version" {
  description = "The .NET version for the Linux Web App."
  type        = string
}

variable "sql_connection_string" {
  description = "The sensitive ADO.NET SQL connection string."
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
}
