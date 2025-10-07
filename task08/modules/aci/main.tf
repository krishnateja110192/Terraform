# Data sources to retrieve Redis secrets from Key Vault
data "azurerm_key_vault_secret" "redis_hostname" {
  key_vault_id = var.key_vault_id
  name         = var.redis_hostname_secret_name
}

data "azurerm_key_vault_secret" "redis_primary_key" {
  key_vault_id = var.key_vault_id
  name         = var.redis_primary_key_secret_name
}

resource "azurerm_container_group" "main" {
  name                = var.aci_name
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_address_type     = "Public"
  dns_name_label      = var.aci_name
  os_type             = "Linux"
  tags                = var.tags

  container {
    name   = "devops-app"
    image  = var.container_image
    cpu    = 1.0
    memory = 1.5

    ports {
      port     = var.container_port
      protocol = "TCP"
    }

    # Standard Environment Variables
    environment_variables = {
      CREATOR        = var.creator
      REDIS_PORT     = var.redis_port
      REDIS_SSL_MODE = var.redis_ssl_mode
    }

    # Secure Environment Variables from Key Vault
    secure_environment_variables = {
      REDIS_URL = data.azurerm_key_vault_secret.redis_hostname.value
      REDIS_PWD = data.azurerm_key_vault_secret.redis_primary_key.value
    }
  }

  image_registry_credential {
    server   = var.acr_server
    username = var.acr_username
    password = var.acr_password
  }
}