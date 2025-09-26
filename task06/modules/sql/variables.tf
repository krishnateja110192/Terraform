variable "location" {
  description = "The Azure Region."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "sql_server_name" {
  description = "The name of the SQL Server."
  type        = string
}

variable "sql_db_name" {
  description = "The name of the SQL Database."
  type        = string
}

variable "sql_db_sku" {
  description = "The service objective name for the SQL Database (e.g., S2)."
  type        = string
}

variable "key_vault_id" {
  description = "The ID of the existing Azure Key Vault."
  type        = string
}

variable "sql_admin_secret_name" {
  description = "Key Vault Secret name for the SQL admin name."
  type        = string
}

variable "sql_password_secret_name" {
  description = "Key Vault Secret name for the SQL admin password."
  type        = string
}

variable "sql_admin_username" {
  description = "The administrator username for the Azure SQL Server."
  type        = string
}

variable "verification_ip" {
  description = "The public IP address to allow through the SQL Firewall."
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

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
}

