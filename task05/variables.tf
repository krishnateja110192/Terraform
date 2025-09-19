#A map of resource group objects, including name and location.
variable "resource_groups" {
  type = map(object({
    name     = string
    location = string
  }))
  description = "A map of resource group objects."
}

#A map of app service plan objects, including name, location, SKU, and OS type.
variable "app_service_plans" {
  type = map(object({
    name         = string
    location_key = string
    worker_count = number
    sku_name     = string
    os_type      = string
  }))
  description = "A map of App Service Plan objects."
}

#A map of app service objects, including name and their associated service plan key.
variable "app_services" {
  type = map(object({
    name                 = string
    location_key         = string
    app_service_plan_key = string
  }))
  description = "A map of App Service objects."
}

#An object for the Traffic Manager profile.
variable "traffic_manager_profile" {
  type = object({
    name               = string
    resource_group_key = string
    routing_method     = string
  })
  description = "An object for the Traffic Manager profile."
}

#The IP address of the verification agent for access restrictions.
variable "verification_agent_ip" {
  type        = string
  description = "IP address of the verification agent."
}

#A map for common tags to apply to all resources.
variable "common_tags" {
  type        = map(string)
  description = "Tags to apply to all resources."
}

variable "ip_restriction_rules" {
  type = list(object({
    name        = string
    priority    = number
    action      = string
    ip_address  = string
    service_tag = string
  }))
  description = "A list of IP restriction rules for the web app."
}