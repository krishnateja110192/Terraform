# --- Required inputs (new schema) ---
variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "aca_name" {
  description = "The name of the Azure Container App."
  type        = string
}

variable "container_app_environment_id" {
  description = "The ID of the Azure Container App Environment."
  type        = string
}


variable "app_image_name" {
  description = "The image repository/name in ACR."
  type        = string
}

variable "user_assigned_identity_id" {
  description = "Resource ID of the User Assigned Identity used by the app (and to pull secrets/ACR)."
  type        = string
}


variable "redis_password_secret_name" {
  description = "The name of the secret for Redis password in Key Vault."
  type        = string
}

variable "redis_hostname_secret_name" {
  description = "The name of the secret for Redis hostname in Key Vault."
  type        = string
}

variable "tags" {
  description = "Tags to assign to the Container App."
  type        = map(string)
}

variable "keyvault_uri" {
  description = "HTTPS URI of the Key Vault (e.g., https://my-kv.vault.azure.net)."
  type        = string
}

variable "acr_login_server" {
  description = "The ACR login server (e.g., contoso.azurecr.io)."
  type        = string
}

variable "image_tag" {
  description = "The tag for the Docker image."
  type        = string
}

variable "acr_resource_id" {
  description = "The Resource ID of the Azure Container Registry (ACR)."
  type        = string
}

variable "user_assigned_identity_principal_id" {
  description = "The Principal ID of the User Assigned Identity for the Container App."
  type        = string
}
