output "kube_config" {
  description = "Kube config to connect to the AKS cluster."
  # FIX: Use the structured attribute, not the raw string
  value     = azurerm_kubernetes_cluster.main.kube_config[0]
  sensitive = true
}

output "kubelet_identity_id" {
  description = "The Object ID of the AKS Kubelet Managed Identity (for CSI Driver)."
  value       = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}

output "aks_id" {
  description = "The ID of the Azure Kubernetes Service cluster."
  value       = azurerm_kubernetes_cluster.main.id
}