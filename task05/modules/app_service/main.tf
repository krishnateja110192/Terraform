resource "azurerm_windows_web_app" "main" {
name                = var.name
location            = var.location
resource_group_name = var.resource_group_name
service_plan_id     = var.app_service_plan_id
tags                = var.tags

site_config {
# Set the default action for IP restrictions to Deny.
# This ensures that only explicitly allowed traffic can access the web app.
ip_restriction_default_action = "Deny"

# Use a dynamic block to create ip_restriction rules based on the input variable.
dynamic "ip_restriction" {
  for_each = var.ip_restrictions
  content {
    name        = ip_restriction.value.name
    priority    = ip_restriction.value.priority
    action      = ip_restriction.value.action
    # Conditionally set ip_address or service_tag based on what is provided in the input.
    ip_address  = ip_restriction.value.ip_address != null ? ip_restriction.value.ip_address : null
    service_tag = ip_restriction.value.service_tag != null ? ip_restriction.value.service_tag : null
  }
}

}

app_settings = {
"WEBSITE_RUN_FROM_PACKAGE" = "1"
}
}