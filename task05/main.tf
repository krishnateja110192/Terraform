provider "azurerm" {
  features {}
}


#Locals block to define reusable values and consolidate data.
locals {

  #Consolidate resource group, app service plan, and app service data to easily map dependencies.
  rg_details  = var.resource_groups
  asp_details = var.app_service_plans
  app_details = var.app_services
}
#--- Resource Groups Module ---
#Create all resource groups using the resource_group module and for_each.
module "resource_group" {
  for_each = local.rg_details
  source   = "./modules/resource_group"
  name     = each.value.name
  location = each.value.location
  tags     = var.common_tags
}

#--- App Service Plans Module ---
#Create all App Service Plans using the app_service_plan module and for_each.
module "app_service_plan" {
  for_each            = local.asp_details
  source              = "./modules/app_service_plan"
  name                = each.value.name
  location            = module.resource_group[each.value.location_key].location
  resource_group_name = module.resource_group[each.value.location_key].name
  worker_count        = each.value.worker_count
  sku_name            = each.value.sku_name
  os_type             = each.value.os_type
  tags                = var.common_tags
}

#--- App Services Module ---
#Create all App Services using the app_service module and for_each.
module "app_service" {
  for_each            = local.app_details
  source              = "./modules/app_service"
  name                = each.value.name
  location            = module.resource_group[each.value.location_key].location
  resource_group_name = module.resource_group[each.value.location_key].name
  app_service_plan_id = module.app_service_plan[each.value.app_service_plan_key].id
  ip_restrictions     = var.ip_restriction_rules
  tags                = var.common_tags
}

#--- Traffic Manager Module ---
#Create the Traffic Manager profile and endpoints using the traffic_manager module.
module "traffic_manager" {
  source              = "./modules/traffic_manager"
  name                = var.traffic_manager_profile.name
  resource_group_name = module.resource_group[var.traffic_manager_profile.resource_group_key].name
  location            = module.resource_group[var.traffic_manager_profile.resource_group_key].location
  routing_method      = var.traffic_manager_profile.routing_method
  tags                = var.common_tags

  #Define the endpoints by mapping the App Service hostnames to the TM endpoints.
  endpoints = {
    endpoint1 = {
      name               = "app1-endpoint"
      target_resource_id = module.app_service["app1"].id
    }
    endpoint2 = {
      name               = "app2-endpoint"
      target_resource_id = module.app_service["app2"].id
    }
  }
}