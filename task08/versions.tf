terraform {
  required_version = ">= 1.5.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.110.0, < 4.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.23.0"
    }
    kubectl = {
      source  = "alekc/kubectl" # maintained fork of gavinbunney/kubectl
      version = "~> 2.1.3"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.6"
    }
  }
}

provider "azurerm" {
  features {}
}

# HashiCorp Kubernetes provider uses the AKS kube_config fields
provider "kubernetes" {
  host                   = module.aks.kube_config.host
  cluster_ca_certificate = base64decode(module.aks.kube_config.cluster_ca_certificate)
  client_certificate     = base64decode(module.aks.kube_config.client_certificate)
  client_key             = base64decode(module.aks.kube_config.client_key)
}

# Kubectl provider: explicitly disable loading any local kubeconfig to avoid localhost fallback
provider "kubectl" {
  alias                  = "aks_kubectl"
  host                   = module.aks.kube_config.host
  cluster_ca_certificate = base64decode(module.aks.kube_config.cluster_ca_certificate)
  client_certificate     = base64decode(module.aks.kube_config.client_certificate)
  client_key             = base64decode(module.aks.kube_config.client_key)
  load_config_file       = false
  apply_retry_count      = 10
}

provider "azapi" {
  skip_provider_registration = false
}
