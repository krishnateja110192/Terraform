terraform {
  required_version = ">= 1.5.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.110.0, < 4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.3"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.6"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = "~> 2.1.3" # Use latest stable version
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.24"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azapi" {
  skip_provider_registration = false
}


provider "kubernetes" {
  alias                  = "aks"
  host                   = module.aks.kube_config.host
  cluster_ca_certificate = base64decode(module.aks.kube_config.cluster_ca_certificate)
  client_certificate     = base64decode(module.aks.kube_config.client_certificate)
  client_key             = base64decode(module.aks.kube_config.client_key)
}

provider "kubectl" {
  alias                  = "aks_kubectl"
  host                   = module.aks.kube_config.host
  cluster_ca_certificate = base64decode(module.aks.kube_config.cluster_ca_certificate)
  client_certificate     = base64decode(module.aks.kube_config.client_certificate)
  client_key             = base64decode(module.aks.kube_config.client_key)
  load_config_file       = false
}
