output "name" {
value       = azurerm_resource_group.main.name
description = "The name of the created resource group."
}

output "location" {
value       = azurerm_resource_group.main.location
description = "The location of the created resource group."
}

output "id" {
value       = azurerm_resource_group.main.id
description = "The ID of the created resource group."
}