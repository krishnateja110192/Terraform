#############################################
# Storage module - main.tf (final corrected)
#############################################

# Archive the application content as a tar.gz
data "archive_file" "app_archive" {
  type             = "tar.gz"
  source_dir       = var.app_content_dir
  output_file_mode = "0644"
  output_path      = "${var.app_content_dir}/${var.archive_file_name}"
}

# Time resources for SAS start/expiry (valid for 24 hours)
resource "time_static" "start_time" {
  rfc3339 = timestamp()
}

resource "time_offset" "expiry_time" {
  base_rfc3339 = time_static.start_time.rfc3339
  offset_hours = 24
}

# Azure Storage Account
resource "azurerm_storage_account" "sa" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = var.replication_type
  tags                     = var.tags
}

# Storage Container
resource "azurerm_storage_container" "container" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = var.container_access_type
}

# Upload the archive as a block blob
resource "azurerm_storage_blob" "blob" {
  name                   = var.archive_file_name
  storage_account_name   = azurerm_storage_account.sa.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = data.archive_file.app_archive.output_path
}

# Storage Account SAS for Blob service (container + object)
data "azurerm_storage_account_sas" "blob_container_sas" {
  connection_string = azurerm_storage_account.sa.primary_connection_string
  https_only        = true
  signed_version    = "2020-02-10"

  start  = time_static.start_time.rfc3339
  expiry = time_offset.expiry_time.rfc3339

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  resource_types {
    service   = false
    container = true
    object    = true
  }

  permissions {
    read    = true
    write   = false
    delete  = false
    list    = true
    add     = false
    create  = false
    update  = false
    process = false
    filter  = false
    tag     = false
    # Remove filter/tag if provider < v3.70
  }
}