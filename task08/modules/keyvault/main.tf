resource "azurerm_key_vault" "main" {
  name                        = var.key_vault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = var.sku_name
  enabled_for_disk_encryption = true
  purge_protection_enabled    = false
  soft_delete_retention_days  = 7
  tags                        = var.tags
}

# Data source for the current user's object ID to grant initial access
data "azurerm_client_config" "current" {}

# Key Vault Access Policy for the current user (to manage secrets)
resource "azurerm_key_vault_access_policy" "current_user_secrets_full" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id
  secret_permissions = [
    "Delete",
    "Get",
    "List",
    "Set",
    "Backup",
    "Restore",
    "Recover",
    "Purge",
  ]
}