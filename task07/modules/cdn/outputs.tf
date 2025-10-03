output "endpoint_hostname" {
  description = "The hostname of the Azure CDN Front Door Endpoint."
  value       = azurerm_cdn_frontdoor_endpoint.endpoint.host_name
}