resource "azurerm_windows_web_app" "main" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.app_service_plan_id
  tags                = var.tags

  site_config {
    always_on                     = true
    ip_restriction_default_action = "Deny"

    dynamic "ip_restriction" {
      for_each = var.ip_restrictions
      content {
        name        = ip_restriction.value.name
        priority    = ip_restriction.value.priority
        action      = ip_restriction.value.action
        ip_address  = ip_restriction.value.ip_address != null ? ip_restriction.value.ip_address : null
        service_tag = ip_restriction.value.service_tag != null ? ip_restriction.value.service_tag : null
      }
    }
  }


  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }
}