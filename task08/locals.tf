locals {
  rg_name        = "${var.name_prefix}-rg"
  aci_name       = "${var.name_prefix}-ci"
  acr_name       = "cmtrey1bz94qmod8cr" # Task parameter requires this specific name: cmtrey1bz94qmod8cr
  aks_name       = "${var.name_prefix}-aks"
  keyvault_name  = "${var.name_prefix}-kv"
  redis_name     = "${var.name_prefix}-redis"
  acr_image_name = "${var.name_prefix}-app"

  # Key Vault Secret Names
  redis_primary_key_secret_name = "redis-primary-key"
  redis_hostname_secret_name    = "redis-hostname"

  # Application-specific values
  app_port = 8080

  # Directory paths
  app_source_path    = "application"
  k8s_manifests_path = "k8s-manifests"

  # AKS defaults
  aks_default_node_pool = {
    name         = "system"
    count        = 1
    vm_size      = "Standard_D2ads_v6"
    os_disk_type = "Ephemeral"
  }
}