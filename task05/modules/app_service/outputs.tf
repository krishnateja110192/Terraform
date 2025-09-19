output "name" {
value       = azurerm_windows_web_app.main.name
description = "The name of the created App Service."
}

output "default_hostname" {
value       = azurerm_windows_web_app.main.default_hostname
description = "The default hostname of the App Service."
}

output "id" {
value       = azurerm_windows_web_app.main.id
description = "The ID of the created App Service."
}