resource "azurerm_redis_cache" "main" {
  name                = var.redis_name
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = var.capacity
  family              = var.sku_family
  sku_name            = var.sku_name
  # Removed 'enable_non_ssl_port = false' to fix the error.
  minimum_tls_version = "1.2"
  tags                = var.tags
}

# Key Vault Secret for Redis Hostname
resource "azurerm_key_vault_secret" "hostname" {
  name         = var.redis_hostname_secret_name
  value        = azurerm_redis_cache.main.hostname
  key_vault_id = var.key_vault_id
  content_type = "redis-hostname"
}

# Key Vault Secret for Redis Primary Key
resource "azurerm_key_vault_secret" "primary_key" {
  name         = var.redis_primary_key_secret_name
  value        = azurerm_redis_cache.main.primary_access_key
  key_vault_id = var.key_vault_id
  content_type = "redis-primary-key"
}