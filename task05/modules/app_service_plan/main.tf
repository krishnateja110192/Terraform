resource "azurerm_service_plan" "main" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = var.os_type
  sku_name            = var.sku_name
  worker_count        = var.worker_count
  tags                = var.tags
}