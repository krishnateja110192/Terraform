provider "azurerm" {
  features {}
}

# Data source to fetch the current client configuration (the user/service principal running Terraform)
data "azurerm_client_config" "current" {}

# 1. Create the Resource Group
resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = local.location
  tags     = var.tags
}

# 2. Data source to access the existing Key Vault to get its ID
data "azurerm_key_vault" "existing_kv" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_rg_name
}

# 3. Grant the deploying identity access to the existing Key Vault (REMOVED TO PREVENT CONFLICT)
# The user running Terraform is assumed to have sufficient Azure RBAC permissions (e.g., Key Vault Administrator or Secret Officer)
# to WRITE the secrets, preventing the need to create a duplicate policy block which caused the error.

# 4. Deploy SQL Server and Database using the module
module "sql" {
  source                        = "./modules/sql"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  sql_server_name               = local.sql_server_name
  sql_db_name                   = local.sql_db_name
  sql_db_sku                    = var.sql_db_sku
  key_vault_id                  = data.azurerm_key_vault.existing_kv.id
  sql_admin_secret_name         = var.sql_admin_name_secret
  sql_password_secret_name      = var.sql_admin_password_secret
  sql_admin_username            = var.sql_admin_username
  verification_ip               = var.allowed_ip_address
  sql_azure_fw_rule_name        = var.sql_azure_fw_rule_name
  sql_verification_fw_rule_name = var.sql_verification_fw_rule_name
  tags                          = var.tags
}

# 5. Deploy App Service Plan and Web App using the module
module "webapp" {
  source                = "./modules/webapp"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  asp_name              = local.asp_name
  asp_sku               = var.app_service_plan_sku
  os_type               = var.app_service_os
  app_name              = local.app_name
  dotnet_version        = var.webapp_dotnet_version
  tags                  = var.tags
  sql_connection_string = module.sql.sql_connection_string
}
