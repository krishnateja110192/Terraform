resource "azurerm_container_registry" "main" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = true
  tags                = var.tags
}

resource "azurerm_container_registry_task" "build_and_push" {
  name                   = "build-${var.image_name}"
  container_registry_id  = azurerm_container_registry.main.id

  platform { os = "Linux" }

  # Optional, if your ACR has a pool named "default"
  #agent_pool_name = "default"

  docker_step {
    # Git context WITH optional branch/subfolder fragment
    #   e.g., https://github.com/org/repo#main:app
    context_path         = var.source_context

    # REQUIRED when context_path is a URL (Git PAT or SAS)
    context_access_token = var.context_access_token

    dockerfile_path      = var.dockerfile_path
    image_names          = ["${var.image_name}:${var.image_tag}"]  # keep lowercase
    push_enabled         = true
  }

  source_trigger {
    name           = "git-trigger"
    source_type    = "Github"

    # Base repo URL ONLY (NO #branch:folder)
    #   e.g., https://github.com/org/repo
    repository_url = var.repository_url

    branch         = "main"
    events         = ["commit"]

    # 👇 This block is REQUIRED (maps to SourceControlAuthProperties)
    authentication {
      token      = var.context_access_token   # reuse the same PAT
      token_type = "PAT"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}