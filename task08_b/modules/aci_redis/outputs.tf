output "fqdn" {
  description = "The FQDN of the Redis ACI instance."
  value       = azurerm_container_group.aci_redis.fqdn
}