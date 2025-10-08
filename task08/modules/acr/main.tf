resource "azurerm_container_registry" "main" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = true
  tags                = var.tags
}

resource "azurerm_container_registry_task" "build_and_push" {
  name                  = "build-${var.image_name}"
  container_registry_id = azurerm_container_registry.main.id

  platform {
    os = "Linux"
  }

  docker_step {
    # Git context with branch and subfolder
    context_path         = "https://github.com/krishnateja110192/Terraform#main:task08/application"
    context_access_token = var.context_access_token
    dockerfile_path      = "Dockerfile"
    image_names          = ["${var.image_name}:${var.image_tag}"]
    push_enabled         = true
  }

  source_trigger {
    name        = "git-trigger"
    source_type = "Github"

    repository_url = "https://github.com/krishnateja110192/Terraform"
    branch         = "main"
    events         = ["commit"]

    authentication {
      token      = var.context_access_token
      token_type = "PAT"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "azurerm_container_registry_task_schedule_run_now" "initial_build" {
  container_registry_task_id = azurerm_container_registry_task.build_and_push.id
  depends_on                 = [azurerm_container_registry_task.build_and_push]

  # Optional: force rerun when tag changes

}
