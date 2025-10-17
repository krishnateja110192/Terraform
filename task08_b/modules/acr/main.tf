# ACR Task to build Docker image

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = false
  tags                = var.tags
}

# ACR Task to build Docker image
resource "azurerm_container_registry_task" "task" {
  name                  = "build-app-image"
  container_registry_id = azurerm_container_registry.acr.id

  platform {
    os = "Linux"
  }

  docker_step {
    dockerfile_path      = "Dockerfile"
    context_path         = var.storage_account_blob_url
    context_access_token = var.storage_account_container_sas
    image_names = [
      "${var.app_image_name}:${var.image_tag}",
    ]

  }



  # FIX: Replace the deprecated 'trigger' block 
  # with the specific trigger block as a direct argument.
  base_image_trigger {
    name = "base_image_trigger"
    type = "Runtime"
  }


  timer_trigger {
    name     = "nightly-build"
    schedule = "15 0 * * *"
    enabled  = true
  }

  timeout_in_seconds = 3600

}


resource "azurerm_container_registry_task_schedule_run_now" "initial_build" {
  container_registry_task_id = azurerm_container_registry_task.task.id
  depends_on                 = [azurerm_container_registry_task.task]
}


# The azurerm_container_registry_task_run resource remains removed.