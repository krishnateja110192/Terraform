variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The Azure region."
  type        = string
}

variable "acr_name" {
  description = "The name of the Azure Container Registry."
  type        = string
}

variable "sku" {
  description = "The SKU for the ACR."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the ACR resource."
  type        = map(string)
}

variable "image_name" {
  description = "The name of the Docker image to build."
  type        = string
}

variable "image_tag" {
  description = "The tag for the Docker image."
  type        = string
}

variable "source_context" {
  description = "The Git repository URL for the application source."
  type        = string
}

variable "context_access_token" {
  description = "Personal Access Token for Git repo access."
  type        = string
  sensitive   = true
}

variable "dockerfile_path" {
  description = "The path to the Dockerfile within the source context."
  type        = string
}

variable "repository_url" {
  description = "The base HTTPS URL of the Git repository for the source trigger (e.g., https://github.com/org/repo.git)."
  type        = string
}