variable "kube_config_raw" {
  description = "The raw Kubernetes config file content."
  type        = string
  sensitive   = true
}

variable "client_certificate" {
  description = "The base64 encoded client certificate data."
  type        = string
  sensitive   = true
}

variable "client_key" {
  description = "The base64 encoded client key data."
  type        = string
  sensitive   = true
}

variable "cluster_ca_certificate" {
  description = "The base64 encoded public certificate."
  type        = string
  sensitive   = true
}

variable "cluster_host" {
  description = "The Kubernetes API server host for the cluster."
  type        = string
}

variable "acr_login_server" {
  description = "The ACR login server name."
  type        = string
}

variable "app_image_name" {
  description = "The name of the Docker image."
  type        = string
}

variable "image_tag" {
  description = "The tag for the Docker image."
  type        = string
}

variable "kv_name" {
  description = "The name of the Key Vault."
  type        = string
}

variable "redis_url_secret_name" {
  description = "The Key Vault secret name for the Redis URL."
  type        = string
}

variable "redis_password_secret_name" {
  description = "The Key Vault secret name for the Redis password."
  type        = string
}

variable "tenant_id" {
  description = "The Azure Active Directory Tenant ID."
  type        = string
}
# modules/k8s/variables.tf

variable "aks_kv_access_identity_id" {
  description = "The Client ID of the Kubelet Identity used for Key Vault access."
  type        = string
}