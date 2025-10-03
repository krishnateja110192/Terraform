
# -----------------------------------------------------------------------------
# Import Blocks for pre-created Resources
# -----------------------------------------------------------------------------
import {
  to = azurerm_resource_group.rg
  id = var.resource_group_id
}

import {
  to = azurerm_storage_account.sa
  id = var.storage_account_id
}

# -----------------------------------------------------------------------------
# Resource Group Import
# -----------------------------------------------------------------------------
resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.location
}

# -----------------------------------------------------------------------------
# Storage Account Import with Configuration Updates
# -----------------------------------------------------------------------------
# NOTE: The data block is no longer strictly needed if we don't reference
# its computed properties in the resource block, minimizing drift risk.

resource "azurerm_storage_account" "sa" {
  name                = local.storage_account_name
  resource_group_name = local.resource_group_name
  location            = var.location

  # Set minimum required attributes for the resource to be valid post-import
  # and align with the pre-created resource state. These are often required 
  # for the provider to accept the configuration.
  account_tier             = "Standard" # Assuming common defaults
  account_replication_type = "GRS"      # Assuming common defaults

  # Required configurations from Task Details
  allow_nested_items_to_be_public  = false
  cross_tenant_replication_enabled = false

  # Use lifecycle block to ignore other potential properties that were not 
  # explicitly configured in this TF file but exist on the imported resource.
  lifecycle {
    ignore_changes = all
  }
}

# -----------------------------------------------------------------------------
# CDN Front Door Module
# -----------------------------------------------------------------------------
module "cdn" {
  source = "./modules/cdn"

  # Pass required variables to the module using locals and other resources
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  cdn_profile_name      = local.cdn_profile_name
  cdn_profile_sku       = var.cdn_profile_sku
  cdn_endpoint_name     = local.cdn_endpoint_name
  cdn_origin_group_name = local.cdn_origin_group_name
  cdn_origin_name       = local.cdn_origin_name
  cdn_route_name        = local.cdn_route_name

  # Storage Account Host
  storage_account_host = azurerm_storage_account.sa.primary_blob_host
  blob_path            = format("/%s", var.blob_filename)
}