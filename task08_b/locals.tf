#############################################
# locals.tf (final corrected)
#############################################

locals {
  rg_name               = "${var.name_prefix}-rg"
  redis_aci_name        = "${var.name_prefix}-redis-ci"
  sa_name               = replace(lower("${var.name_prefix}sa"), "-", "")
  sa_container_name     = "app-content"
  keyvault_name         = "${var.name_prefix}-kv"
  acr_name              = replace(lower("${var.name_prefix}cr"), "-", "")
  aca_env_name          = "${var.name_prefix}-cae"
  aca_name              = "${var.name_prefix}-ca"
  aks_name              = "${var.name_prefix}-aks"
  aks_default_pool_name = "system"

  # Archive details
  archive_source_dir = "${path.root}/application"
  archive_file_name  = "app-content.tar.gz"
  k8s_manifests_path = "${path.root}/k8s-manifests"

  # ACR image and tag
  acr_image_tag = "latest"

  # ACR Task details
  acr_task_name                             = "build-app-image"
  acr_task_source_context_template          = "/acr/tasks/app_build.tar.gz"
  acr_task_source_context_template_filename = "acr_task_source_context.yaml.tftpl"

  # Container URL from storage module output
  container_url = module.storage.container_url
}