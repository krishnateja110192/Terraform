output "app_hostname" {
  description = "The default hostname of the Linux Web App."
  value       = azurerm_linux_web_app.web_app.default_hostname
}
