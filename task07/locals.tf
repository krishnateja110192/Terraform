locals {
  # Base for naming
  base = var.project_name_base

  # Resource Group and Storage Account names (following task parameters)
  resource_group_name  = format("%s-rg", local.base)
  storage_account_name = format("%ssa", replace(local.base, "-", "")) # Storage account names must be lowercase and contain no hyphens. (cmtrey1bz94qmod7sa)

  # CDN Front Door resource names (following task parameters)
  cdn_profile_name      = format("%s-fd-profile", local.base)
  cdn_endpoint_name     = format("%s-fd-endpoint", local.base)
  cdn_origin_group_name = format("%s-fd-origin-group", local.base)
  cdn_origin_name       = format("%s-fd-origin", local.base)
  cdn_route_name        = "default" # Use the fixed name from the task parameters

  # task07/locals.tf (UPDATED)


}