# 1. Create the Azure App Service Plan (Linux)
resource "azurerm_service_plan" "asp" {
  name                = var.asp_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.asp_sku
  tags                = var.tags
}

# 2. Create the Azure Linux Web Application
resource "azurerm_linux_web_app" "web_app" {
  name                = var.app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.asp.id
  enabled             = true
  tags                = var.tags

  # Configure the .NET version for the Linux App Service
  site_config {
    application_stack {
      dotnet_version = var.dotnet_version
    }
  }

  # Set the database connection string as an Azure Connection String
  # This uses the connection string outputted from the SQL module.
  connection_string {
    name  = "DefaultConnection"
    type  = "SQLServer"
    value = var.sql_connection_string
  }
}
