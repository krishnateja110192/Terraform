variable "name" {
type        = string
description = "The name of the App Service Plan."
}

variable "location" {
type        = string
description = "The Azure region where the App Service Plan should be created."
}

variable "resource_group_name" {
type        = string
description = "The name of the Resource Group where the App Service Plan will be created."
}

variable "worker_count" {
type        = number
description = "The number of workers (instances) to allocate to the App Service Plan."
}

variable "sku_name" {
type        = string
description = "The SKU name for the App Service Plan."
}

variable "os_type" {
type        = string
description = "The operating system type for the App Service Plan (e.g., 'Windows', 'Linux')."
}

variable "tags" {
type        = map(string)
description = "Tags to apply to the App Service Plan."
}