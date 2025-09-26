# 1. Generate a secure random password for the SQL administrator
resource "random_password" "sql_admin_password" {
  length  = 16
  special = true
  numeric = true
  upper   = true
  lower   = true
}

# 2. Store the SQL Admin Username in Key Vault
resource "azurerm_key_vault_secret" "sql_admin_name_secret" {
  name         = var.sql_admin_secret_name
  value        = var.sql_admin_username
  key_vault_id = var.key_vault_id
  tags         = var.tags
}

# 3. Store the Generated SQL Admin Password in Key Vault
resource "azurerm_key_vault_secret" "sql_admin_password_secret" {
  name         = var.sql_password_secret_name
  value        = random_password.sql_admin_password.result
  key_vault_id = var.key_vault_id
  tags         = var.tags
  # Mark secret value as sensitive
  lifecycle {
    ignore_changes = [
      value,
    ]
  }
}

# 4. Create the Azure SQL Server
resource "azurerm_mssql_server" "sql_server" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0" # Latest stable version
  administrator_login          = var.sql_admin_username
  administrator_login_password = random_password.sql_admin_password.result
  minimum_tls_version          = "1.2"
  tags                         = var.tags
}

# 5. Create the Azure SQL Database
resource "azurerm_mssql_database" "sql_db" {
  name         = var.sql_db_name
  server_id    = azurerm_mssql_server.sql_server.id
  sku_name     = var.sql_db_sku
  min_capacity = 0.5 # Default minimum capacity for S2
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  tags         = var.tags
}

# 6. Firewall Rule: Allow connection from Azure services (0.0.0.0 to 0.0.0.0)
resource "azurerm_mssql_firewall_rule" "azure_services_rule" {
  name             = var.sql_azure_fw_rule_name # Using variable
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# 7. Firewall Rule: Allow connection from the specified verification IP
resource "azurerm_mssql_firewall_rule" "verification_ip_rule" {
  name             = var.sql_verification_fw_rule_name # Using variable
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = var.verification_ip
  end_ip_address   = var.verification_ip
}



