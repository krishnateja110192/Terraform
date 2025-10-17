# Azure Container App
resource "azurerm_container_app" "aca" {
  name                         = var.aca_name
  container_app_environment_id = var.container_app_environment_id
  resource_group_name          = var.resource_group_name
  tags                         = var.tags

  # Single revision mode (no traffic_weight blocks allowed in ingress)
  revision_mode = "Single" # [1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app)

  # Pull Key Vault secrets and ACR via User Assigned Identity
  identity {
    type         = "UserAssigned"
    identity_ids = [var.user_assigned_identity_id]
  }

  # --- Secrets pulled from Key Vault (versionless IDs are fine) ---
  # NOTE: identity must be set on the secret block when using key_vault_secret_id
  #       and the identity must have permissions to read secrets. [1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app)[2](https://support.hashicorp.com/hc/en-us/articles/34643944045075-Troubleshooting-azurerm-provider-issue-not-able-to-fetch-keyvault-secret-s-while-deploying-container-app)
  secret {
    name                = "redis-url"
    identity            = var.user_assigned_identity_id
    key_vault_secret_id = "${trimsuffix(var.keyvault_uri, "/")}/secrets/${var.redis_hostname_secret_name}"
  }

  secret {
    name                = "redis-key"
    identity            = var.user_assigned_identity_id
    key_vault_secret_id = "${trimsuffix(var.keyvault_uri, "/")}/secrets/${var.redis_password_secret_name}"
  }

  # --- Ingress (Single mode -> no traffic_weight) ---
  ingress {
    external_enabled = true
    target_port      = 8080
    transport        = "auto" # valid values: auto | http | http2 | tcp [1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app)

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }

  }


  # --- Registry auth via the same UAI (no username/password needed) ---
  registry {
    server   = var.acr_login_server
    identity = var.user_assigned_identity_id # UAI must have ACR pull permissions [1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app)
  }

  template {
    # Scale
    min_replicas = 1
    max_replicas = 3

    container {
      name   = "app-container"
      image  = "${var.acr_login_server}/${var.app_image_name}:${var.image_tag}"
      cpu    = 0.5
      memory = "1.0Gi"

      # Standard env
      env {
        name  = "CREATOR"
        value = "ACA"
      }
      env {
        name  = "REDIS_PORT"
        value = "6379"
      }
      # Secrets to env
      env {
        name        = "REDIS_URL"
        secret_name = "redis-url"
      }
      env {
        name        = "REDIS_PWD"
        secret_name = "redis-key"
      }
    }
  }
  depends_on = [
    azurerm_role_assignment.aca_acr_pull
  ]
}

# Grant the Container App's User Assigned Identity (UAI) AcrPull permission on the ACR
# modules/aca/main.tf (Add this block at the end)

# Grant the Container App's UAI the AcrPull role on the ACR
resource "azurerm_role_assignment" "aca_acr_pull" {
  scope                = var.acr_resource_id # Use the new ACR Resource ID input
  role_definition_name = "AcrPull"
  principal_id         = var.user_assigned_identity_principal_id # Use the new UAI Principal ID input

  # Ensure the role assignment creation happens after the UAI is fully available
}