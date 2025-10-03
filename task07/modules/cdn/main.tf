# -----------------------------------------------------------------------------
# Azure CDN Front Door Profile
# -----------------------------------------------------------------------------
resource "azurerm_cdn_frontdoor_profile" "profile" {
  name                = var.cdn_profile_name
  resource_group_name = var.resource_group_name
  sku_name            = var.cdn_profile_sku
  tags                = var.common_tags
}

# -----------------------------------------------------------------------------
# Azure CDN Front Door Endpoint
# -----------------------------------------------------------------------------
resource "azurerm_cdn_frontdoor_endpoint" "endpoint" {
  name                     = var.cdn_endpoint_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.profile.id
  enabled                  = true
}

# -----------------------------------------------------------------------------
# Azure CDN Front Door Origin Group
# -----------------------------------------------------------------------------
resource "azurerm_cdn_frontdoor_origin_group" "origin_group" {
  name                     = var.cdn_origin_group_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.profile.id

  health_probe {
    interval_in_seconds = 100
    path                = "/"
    protocol            = "Https"
    request_type        = "HEAD"
  }

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }
}

# -----------------------------------------------------------------------------
# Azure CDN Front Door Origin (Storage Account Blob Host)
# -----------------------------------------------------------------------------
resource "azurerm_cdn_frontdoor_origin" "origin" {
  name                          = var.cdn_origin_name
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin_group.id
  host_name                     = var.storage_account_host
  http_port                     = 80
  https_port                    = 443
  origin_host_header            = var.storage_account_host
  priority                      = 1
  weight                        = 500
  enabled                       = true

  # Required attribute
  certificate_name_check_enabled = true
}

# -----------------------------------------------------------------------------
# Azure CDN Front Door Route - FINAL CORRECTED VERSION
# -----------------------------------------------------------------------------
resource "azurerm_cdn_frontdoor_route" "route" {
  name                          = var.cdn_route_name
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin_group.id

  # Required attributes
  patterns_to_match        = ["/*"]
  cdn_frontdoor_origin_ids = [azurerm_cdn_frontdoor_origin.origin.id]
  supported_protocols      = ["Http", "Https"]
  forwarding_protocol      = "HttpsOnly"

  # The attribute causing the error is removed. 
  # 'link_to_default_domain = true' is the default behavior and ensures access via the endpoint hostname.
  link_to_default_domain = true

  cache {
    query_string_caching_behavior = "UseQueryString"

    # FIX: Compression is enabled, so content types must be specified.
    compression_enabled = true
    content_types_to_compress = [
      "text/html",
      "text/css",
      "text/javascript",
      "application/json",
      "application/javascript",
      "application/xml",
    ]
  }
}