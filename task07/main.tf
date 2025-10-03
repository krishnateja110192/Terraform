# task07/main.tf (UPDATED)

# -----------------------------------------------------------------------------
# Import Blocks for pre-created Resources - FIXED
# -----------------------------------------------------------------------------
import {
  to = azurerm_resource_group.rg
  # FIX: Use a local value instead of var.*
  id = "/subscriptions/cc7ea49d-2277-4c78-bba6-063045232ca6/resourceGroups/cmtr-ey1bz94q-mod7-rg"
}

import {
  to = azurerm_storage_account.sa
  # FIX: Use a local value instead of var.*
  id = "/subscriptions/cc7ea49d-2277-4c78-bba6-063045232ca6/resourceGroups/cmtr-ey1bz94q-mod7-rg/providers/Microsoft.Storage/storageAccounts/cmtrey1bz94qmod7sa"

}

# -----------------------------------------------------------------------------
# Resource Group Import
# -----------------------------------------------------------------------------
resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# -----------------------------------------------------------------------------
# Storage Account Import with Configuration Updates
# -----------------------------------------------------------------------------
resource "azurerm_storage_account" "sa" {
  name                     = local.storage_account_name
  resource_group_name      = local.resource_group_name
  location                 = var.location
  tags                     = local.common_tags
  account_tier             = "Standard"
  account_replication_type = "GRS"

  allow_nested_items_to_be_public  = false
  cross_tenant_replication_enabled = false

  lifecycle {
    ignore_changes = all
  }
}

# -----------------------------------------------------------------------------
# CDN Front Door Module
# -----------------------------------------------------------------------------
module "cdn" {
  source = "./modules/cdn"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  cdn_profile_name      = local.cdn_profile_name
  cdn_profile_sku       = var.cdn_profile_sku
  cdn_endpoint_name     = local.cdn_endpoint_name
  cdn_origin_group_name = local.cdn_origin_group_name
  cdn_origin_name       = local.cdn_origin_name
  cdn_route_name        = local.cdn_route_name
  common_tags           = local.common_tags
  storage_account_host  = azurerm_storage_account.sa.primary_blob_host
  blob_path             = format("/%s", var.blob_filename)
}