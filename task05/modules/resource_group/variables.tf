variable "name" {
  type        = string
  description = "The name of the resource group."
}

variable "location" {
  type        = string
  description = "The Azure region where the resource group should be created."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the resource group."
}