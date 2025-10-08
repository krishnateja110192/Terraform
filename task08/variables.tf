variable "name_prefix" {
  description = "A prefix for all resource names."
  type        = string
}

variable "location" {
  description = "The Azure region to create resources in."
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all taggable resources."
  type        = map(string)
}

variable "git_pat" {
  description = "Personal Access Token for the Git repository containing the application source code."
  type        = string
  sensitive   = true
}

variable "acr_image_tag" {
  description = "The tag to use for the Docker image."
  type        = string
  default     = "v1.0.0"
}

variable "repository_url" {
  description = "The base HTTPS URL of the Git repository to set up the ACR Task trigger (no branch or subfolder). E.g., https://github.com/Azure-Samples/aci-helloworld.git"
  type        = string
}