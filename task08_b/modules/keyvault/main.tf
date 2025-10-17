resource "azurerm_key_vault" "kv" {
  name                = var.keyvault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id
  sku_name            = var.sku_name

  # Access policy model (explicit)
  enable_rbac_authorization = false

  # Platform & safety settings
  enabled_for_disk_encryption = false
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false # set true for production

  # Networking (tighten if needed)
  public_network_access_enabled = true
  # network_acls { default_action = "Deny" bypass = "AzureServices" ip_rules = [] }

  tags = var.tags
}

resource "azurerm_key_vault_access_policy" "current_user_secrets_full" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = var.tenant_id
  object_id    = var.current_user_object_id
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