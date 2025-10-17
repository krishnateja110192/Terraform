output "id" {
  description = "The ID of the Key Vault."
  value       = azurerm_key_vault.kv.id
}
output "vault_uri" {
  description = "The URI (DNS name) of the Azure Key Vault."
  # Assuming your Key Vault resource is named 'keyvault'
  value = azurerm_key_vault.kv.vault_uri
}