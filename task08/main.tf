resource "azurerm_resource_group" "main" {
  name     = local.rg_name
  location = var.location
  tags     = var.common_tags
}

# 1. Key Vault
module "keyvault" {
  source = "./modules/keyvault"
  # This argument is correct: maps to module.keyvault.variables.tf
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  key_vault_name      = local.keyvault_name
  sku_name            = "standard"
  tags                = var.common_tags
}

# 2. Azure Cache for Redis
module "redis" {
  source                        = "./modules/redis"
  resource_group_name           = azurerm_resource_group.main.name
  location                      = azurerm_resource_group.main.location
  redis_name                    = local.redis_name
  capacity                      = 2
  sku_name                      = "Basic"
  sku_family                    = "C"
  tags                          = var.common_tags
  key_vault_id                  = module.keyvault.key_vault_id
  redis_primary_key_secret_name = local.redis_primary_key_secret_name
  redis_hostname_secret_name    = local.redis_hostname_secret_name
  depends_on = [
    module.keyvault
  ]
}

# 3. Azure Container Registry (ACR)
module "acr" {
  source               = "./modules/acr"
  resource_group_name  = azurerm_resource_group.main.name
  location             = azurerm_resource_group.main.location
  acr_name             = local.acr_name
  sku                  = "Basic"
  tags                 = var.common_tags
  image_name           = local.acr_image_name
  image_tag            = var.acr_image_tag
  source_context       = "https://github.com/krishnateja110192/Terraform.git" # Example URL
  context_access_token = var.context_access_token
  dockerfile_path      = "task08/application/Dockerfile"
  repository_url       = var.repository_url
}

# 4. Azure Container Instance (ACI)
module "aci" {
  source                        = "./modules/aci"
  resource_group_name           = azurerm_resource_group.main.name
  location                      = azurerm_resource_group.main.location
  aci_name                      = local.aci_name
  tags                          = var.common_tags
  container_image               = "${module.acr.acr_login_server}/${local.acr_image_name}:${var.acr_image_tag}"
  acr_server                    = module.acr.acr_login_server
  acr_username                  = module.acr.acr_admin_username
  acr_password                  = module.acr.acr_admin_password
  key_vault_id                  = module.keyvault.key_vault_id
  redis_hostname_secret_name    = local.redis_hostname_secret_name
  redis_primary_key_secret_name = local.redis_primary_key_secret_name
  container_port                = local.app_port
  creator                       = "ACI"
  redis_port                    = "6380"
  redis_ssl_mode                = "True"

  depends_on = [
    module.acr,
    module.redis
  ]
}

# 5. Azure Kubernetes Service (AKS)
module "aks" {
  source                            = "./modules/aks"
  resource_group_name               = azurerm_resource_group.main.name
  location                          = azurerm_resource_group.main.location
  aks_name                          = local.aks_name
  tags                              = var.common_tags
  default_node_pool_name            = local.aks_default_node_pool.name
  default_node_pool_count           = local.aks_default_node_pool.count
  default_node_pool_vm_size         = local.aks_default_node_pool.vm_size
  default_node_pool_os_disk_type    = local.aks_default_node_pool.os_disk_type
  default_node_pool_os_disk_size_gb = local.aks_default_node_pool.os_disk_size_gb
  acr_id                            = module.acr.acr_id
  key_vault_id                      = module.keyvault.key_vault_id

  depends_on = [
    module.acr,
    module.keyvault
  ]
}

resource "kubectl_manifest" "secret_provider_class" {
  provider = kubectl.aks_kubectl
  yaml_body = templatefile("${local.k8s_manifests_path}/secret-provider.yaml.tftpl", {
    aks_kv_access_identity_id  = module.aks.kubelet_identity_client_id
    kv_name                    = module.keyvault.key_vault_name
    redis_url_secret_name      = local.redis_hostname_secret_name
    redis_password_secret_name = local.redis_primary_key_secret_name
    tenant_id                  = data.azurerm_client_config.current.tenant_id
  })
  depends_on = [module.aks]
}

resource "kubectl_manifest" "deployment" {
  provider = kubectl.aks_kubectl
  yaml_body = templatefile("${local.k8s_manifests_path}/deployment.yaml.tftpl", {
    acr_login_server = module.acr.acr_login_server
    app_image_name   = local.acr_image_name
    image_tag        = var.acr_image_tag
  })
  wait_for {
    field {
      key   = "status.availableReplicas"
      value = "1"
    }
  }
  depends_on = [kubectl_manifest.secret_provider_class]
}

resource "kubectl_manifest" "service" {
  provider  = kubectl.aks_kubectl
  yaml_body = file("${local.k8s_manifests_path}/service.yaml")
  wait_for {
    field {
      key        = "status.loadBalancer.ingress.[0].ip"
      value      = "^(\\d+(\\.|$)){4}"
      value_type = "regex"
    }
  }
  depends_on = [kubectl_manifest.deployment]
}

data "kubernetes_service" "app_service" {
  depends_on = [kubectl_manifest.service]
  metadata { name = "redis-flask-app-service" }
}

# Azure Client Configuration Data Source
data "azurerm_client_config" "current" {}