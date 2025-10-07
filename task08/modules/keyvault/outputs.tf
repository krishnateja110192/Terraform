output "key_vault_id" {
  description = "The ID of the Azure Key Vault."
  value       = azurerm_key_vault.main.id
}

output "key_vault_name" {
  description = "The name of the Azure Key Vault."
  value       = azurerm_key_vault.main.name
}

output "tenant_id" {
  description = "The tenant ID of the Key Vault."
  value       = azurerm_key_vault.main.tenant_id
}