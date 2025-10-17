#############################################
# Storage module - outputs.tf (final)
#############################################

# Blob URLs
output "blob_url" {
  description = "The full URL of the uploaded blob (without SAS)."
  value       = azurerm_storage_blob.blob.url
}

output "blob_url_with_sas" {
  description = "The blob URL with SAS token appended."
  value       = "${azurerm_storage_blob.blob.url}?${data.azurerm_storage_account_sas.blob_container_sas.sas}"
  sensitive   = true
}

# Container URLs
output "container_url" {
  description = "The container URL (without SAS)."
  value       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.container.name}"
}

output "container_url_with_sas" {
  description = "The container URL with SAS token appended."
  value       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.container.name}?${data.azurerm_storage_account_sas.blob_container_sas.sas}"
  sensitive   = true
}

# SAS token (query string only; no leading '?')
output "container_sas" {
  description = "SAS token string for the container scope (use by appending '?<token>' to a URL)."
  value       = data.azurerm_storage_account_sas.blob_container_sas.sas
  sensitive   = true
}