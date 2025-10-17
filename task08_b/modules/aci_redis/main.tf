# Random password for Redis
resource "random_password" "redis_password" {
  length  = 16
  special = false # Set to false to exclude all special characters
  # You could set 'min_special' to 0 or 1 and keep 'special = true' but remove problem characters 
  # from override_special, but setting special=false is quickest for testing.
}

# Azure Container Group instance (ACI) for Redis
resource "azurerm_container_group" "aci_redis" {
  name                = var.aci_name
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_address_type     = "Public"
  dns_name_label      = lower(var.aci_name)
  sku                 = var.redis_aci_sku
  tags                = var.tags


  container {
    name   = "redis"
    image  = var.redis_image
    cpu    = 0.5
    memory = 1.5

    ports {
      port     = 6379
      protocol = "TCP"
    }

    commands = ["/bin/sh", "-c", "redis-server --protected-mode no --requirepass ${random_password.redis_password.result}  --bind 0.0.0.0"]
  }

  os_type = "Linux"
}

# Key Vault secret for Redis password
resource "azurerm_key_vault_secret" "redis_password_secret" {
  name         = var.redis_password_secret_name
  value        = random_password.redis_password.result
  key_vault_id = var.keyvault_id
  content_type = "Redis Password"
}

# Key Vault secret for Redis hostname (FQDN)
resource "azurerm_key_vault_secret" "redis_hostname_secret" {
  name         = var.redis_hostname_secret_name
  value        = azurerm_container_group.aci_redis.fqdn
  key_vault_id = var.keyvault_id
  content_type = "Redis FQDN"
}