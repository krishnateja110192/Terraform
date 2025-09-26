variable "name_prefix" {
  description = "Prefix for all resources, e.g., 'cmaz-ey1bz94q-mod6'."
  type        = string
}

variable "location" {
  description = "The Azure Region to deploy resources."
  type        = string
  default     = "eastus2"
}

variable "key_vault_rg_name" {
  description = "Resource Group name of the existing Key Vault."
  type        = string
}

variable "key_vault_name" {
  description = "Name of the existing Key Vault."
  type        = string
}

variable "sql_admin_username" {
  description = "The administrator username for the Azure SQL Server."
  type        = string
  default     = "sqladmin"
}

variable "sql_admin_name_secret" {
  description = "Key Vault Secret name for the SQL admin name."
  type        = string
}

variable "sql_admin_password_secret" {
  description = "Key Vault Secret name for the SQL admin password."
  type        = string
}

variable "allowed_ip_address" {
  description = "The public IP address to allow through the SQL Firewall (e.g., verification agent IP)."
  type        = string
}

variable "sql_azure_fw_rule_name" {
  description = "Name of the SQL Server Firewall Rule to allow Azure services."
  type        = string
}

variable "sql_verification_fw_rule_name" {
  description = "Name of the SQL Server Firewall Rule for the verification agent IP."
  type        = string
}

variable "sql_db_sku" {
  description = "The service objective name for the SQL Database (e.g., S2, P1, Basic)."
  type        = string
}

variable "app_service_plan_sku" {
  description = "The SKU for the App Service Plan (e.g., P0v3)."
  type        = string
}

variable "app_service_os" {
  description = "The operating system type for the App Service Plan (Linux or Windows)."
  type        = string
}

variable "webapp_dotnet_version" {
  description = "The .NET version for the Linux Web App (e.g., 8.0)."
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}
variable "local_ip_name" {
  description = "Name of the firewall rule for local IP access"
  type        = string
  default     = "allow-local-ip"
}

variable "local_ip_address" {
  description = "Public IP address to allow access to SQL Server from local machine"
  type        = string
}
