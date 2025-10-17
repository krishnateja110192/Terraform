# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
  tags     = var.tags
}

# Identity for Key Vault Access Policy
data "azurerm_client_config" "current" {}

# Key Vault Module
module "keyvault" {
  source                 = "./modules/keyvault"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  keyvault_name          = local.keyvault_name
  sku_name               = var.keyvault_sku_name
  tenant_id              = data.azurerm_client_config.current.tenant_id
  current_user_object_id = data.azurerm_client_config.current.object_id
  tags                   = var.tags
}

# Storage Account Module
module "storage" {
  source              = "./modules/storage"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  # Match variables.tf in storage module
  storage_account_name  = local.sa_name
  replication_type      = var.sa_replication_type
  container_name        = local.sa_container_name
  container_access_type = var.sa_container_access_type
  app_content_dir       = local.archive_source_dir
  archive_file_name     = local.archive_file_name
  tags                  = var.tags
}

# Redis ACI Module
module "aci_redis" {
  source                     = "./modules/aci_redis"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  aci_name                   = local.redis_aci_name
  redis_image                = var.redis_aci_image
  redis_aci_sku              = var.redis_aci_sku
  keyvault_id                = module.keyvault.id
  redis_password_secret_name = var.keyvault_redis_password_secret_name
  redis_hostname_secret_name = var.keyvault_redis_hostname_secret_name
  tags                       = var.tags
  depends_on                 = [module.keyvault] # Ensure KV is created before setting secrets
}

# ACR Module
module "acr" {
  source                        = "./modules/acr"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  acr_name                      = local.acr_name
  sku                           = var.acr_sku
  app_image_name                = var.acr_app_image_name
  image_tag                     = local.acr_image_tag
  storage_account_blob_url      = module.storage.blob_url
  storage_account_container_sas = module.storage.container_sas
  tags                          = var.tags
  depends_on                    = [module.storage]
}

# AKS Module
module "aks" {
  source = "./modules/aks"



  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  aks_name            = local.aks_name
  default_pool_name   = local.aks_default_pool_name
  node_count          = var.aks_default_node_pool_count
  node_size           = var.aks_default_node_size
  os_disk_type        = var.aks_default_node_os_disk_type
  os_disk_size_gb     = var.aks_default_node_os_disk_size_gb
  acr_login_server    = module.acr.login_server
  acr_resource_id     = module.acr.acr_id
  keyvault_id         = module.keyvault.id
  keyvault_tenant_id  = data.azurerm_client_config.current.tenant_id
  tags                = var.tags
  depends_on = [module.acr,
  module.keyvault]
}

# --------------------------------------------------------------------------
# KUBERNETES PROVIDER CONFIGURATION (Required for module "k8s")
# --------------------------------------------------------------------------

# ACA Module
# -----------------------------
# User Assigned Identity (for ACA)
# -----------------------------
resource "azurerm_user_assigned_identity" "aca_identity" {
  name                = "${local.aca_name}-uai"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags

  depends_on = [azurerm_resource_group.rg]
}

# -----------------------------
# Container Apps Environment
# -----------------------------
resource "azurerm_container_app_environment" "cae" {
  name                = local.aca_env_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}
module "aca" {
  source = "./modules/aca"

  resource_group_name = azurerm_resource_group.rg.name
  aca_name            = local.aca_name

  # New, correct inputs:
  container_app_environment_id        = azurerm_container_app_environment.cae.id
  user_assigned_identity_id           = azurerm_user_assigned_identity.aca_identity.id
  acr_resource_id                     = module.acr.acr_id # Pass the ACR's full Resource ID
  user_assigned_identity_principal_id = azurerm_user_assigned_identity.aca_identity.principal_id

  # ACR & image
  acr_login_server = module.acr.login_server
  app_image_name   = var.acr_app_image_name
  image_tag        = local.acr_image_tag

  # Key Vault URI + secret names
  keyvault_uri               = module.keyvault.vault_uri
  redis_password_secret_name = var.keyvault_redis_password_secret_name
  redis_hostname_secret_name = var.keyvault_redis_hostname_secret_name

  tags = var.tags

  depends_on = [
    azurerm_key_vault_access_policy.aca_uai,
    module.acr,
    module.aci_redis
  ]

}
# Allow ACA UAI to read secrets from KV (Access Policy model)
resource "azurerm_key_vault_access_policy" "aca_uai" {
  key_vault_id = module.keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.aca_identity.principal_id

  secret_permissions = [
    "Get",
    "List",
  ]
}



# Kubernetes Deployment Module
module "k8s" {
  source = "./modules/k8s"
  providers = {
    kubernetes = kubernetes.aks
    kubectl    = kubectl.aks_kubectl # <-- This line is crucial
  }
  kube_config_raw            = module.aks.kube_config_raw
  client_certificate         = module.aks.kube_config.client_certificate
  client_key                 = module.aks.kube_config.client_key
  cluster_ca_certificate     = module.aks.kube_config.cluster_ca_certificate
  cluster_host               = module.aks.kube_config.host
  aks_kv_access_identity_id  = module.aks.kubelet_identity_client_id
  acr_login_server           = module.acr.login_server
  app_image_name             = var.acr_app_image_name
  image_tag                  = local.acr_image_tag
  kv_name                    = local.keyvault_name
  redis_url_secret_name      = var.keyvault_redis_hostname_secret_name
  redis_password_secret_name = var.keyvault_redis_password_secret_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id

  depends_on = [module.aks]

  # Ensure all resources are ready
}

