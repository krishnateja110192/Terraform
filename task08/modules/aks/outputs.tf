# modules/aks/outputs.tf

# AKS kubeconfig pieces (client cert auth)
output "kube_config" {
  description = "Kube config parts for providers"
  value = {
    host                   = azurerm_kubernetes_cluster.main.kube_config[0].host
    client_certificate     = azurerm_kubernetes_cluster.main.kube_config[0].client_certificate
    client_key             = azurerm_kubernetes_cluster.main.kube_config[0].client_key
    cluster_ca_certificate = azurerm_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate
  }
  sensitive = true
}

# Kubelet identity (used by CSI and ACR pull)
output "kubelet_identity_id" {
  description = "Object ID of kubelet user-assigned identity"
  value       = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}

# (optional) raw kubeconfig for debugging (do not use in provider directly)
output "kube_config_raw" {
  value     = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive = true
}
# already present outputs ...
output "kubelet_identity_client_id" {
  value       = azurerm_kubernetes_cluster.main.kubelet_identity[0].client_id
  description = "ClientId of the kubelet user-assigned identity"
}