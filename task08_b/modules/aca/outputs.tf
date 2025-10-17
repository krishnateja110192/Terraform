
# Stable ingress FQDN (the 'Application URL' on the portal UI)
output "fqdn" {
  description = "The stable ingress FQDN of the Container App."
  value       = azurerm_container_app.aca.ingress[0].fqdn
}

output "container_app_id" {
  description = "Resource ID of the Container App."
  value       = azurerm_container_app.aca.id
}

output "container_app_name" {
  description = "Name of the Container App."
  value       = azurerm_container_app.aca.name
}

output "latest_revision_name" {
  description = "Name of the latest Container App revision."
  value       = azurerm_container_app.aca.latest_revision_name
}


output "latest_revision_fqdn" {
  description = "FQDN of the latest revision of the Container App."
  value       = azurerm_container_app.aca.latest_revision_fqdn
}
