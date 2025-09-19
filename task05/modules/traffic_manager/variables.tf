variable "name" {
type        = string
description = "The name of the Traffic Manager profile."
}

variable "resource_group_name" {
type        = string
description = "The name of the Resource Group where the Traffic Manager profile will be created."
}

variable "location" {
type        = string
description = "The Azure region where the Traffic Manager profile will be created."
}

variable "routing_method" {
type        = string
description = "The routing method for the Traffic Manager profile."
}

variable "tags" {
type        = map(string)
description = "Tags to apply to the Traffic Manager profile."
}

variable "endpoints" {
type = map(object({
name               = string
target_resource_id = string
}))
description = "A map of App Service endpoints for the Traffic Manager profile."
}