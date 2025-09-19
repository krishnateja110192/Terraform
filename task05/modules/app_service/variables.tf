variable "name" {
type        = string
description = "The name of the App Service."
}

variable "location" {
type        = string
description = "The Azure region where the App Service should be created."
}

variable "resource_group_name" {
type        = string
description = "The name of the Resource Group where the App Service will be created."
}

variable "app_service_plan_id" {
type        = string
description = "The ID of the App Service Plan to host the web app."
}

variable "ip_restrictions" {
type = list(object({
name        = string
priority    = number
action      = string
ip_address  = string
service_tag = string
}))
description = "A list of IP restriction rules for the web app."
}

variable "tags" {
type        = map(string)
description = "Tags to apply to the App Service."
}