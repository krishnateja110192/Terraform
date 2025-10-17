output "acr_id" {
  description = "The ID of the Azure Container Registry."
  value       = azurerm_container_registry.acr.id
}

output "login_server" {
  description = "The ACR login server name."
  value       = azurerm_container_registry.acr.login_server
}

output "task_id" {
  description = "The ID of the ACR Task."
  value       = azurerm_container_registry_task.task.id
}