# Managed Kubernetes Cluster (AKS)
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = lower(var.aks_name)
  tags                = var.tags

  default_node_pool {
    name            = var.default_pool_name
    node_count      = var.node_count
    vm_size         = var.node_size
    os_disk_type    = var.os_disk_type
    os_disk_size_gb = var.os_disk_size_gb
  }

  identity {
    type = "SystemAssigned"
  }


  key_vault_secrets_provider {
    secret_rotation_enabled = false
  }


}

# Key Vault Access Policy to allow AKS to get secrets
# Key Vault Access Policy to allow AKS **Nodes (Kubelet Identity)** to get secrets
resource "azurerm_key_vault_access_policy" "aks_kv_access" {
  key_vault_id       = var.keyvault_id
  tenant_id          = azurerm_kubernetes_cluster.aks.identity[0].tenant_id
  object_id          = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id # <- azurekeyvaultsecretsprovider-... MI
  secret_permissions = ["Get", "List"]

  depends_on = [azurerm_kubernetes_cluster.aks]


  lifecycle {
    create_before_destroy = true
  }

}

# Role Assignment to allow AKS **Control Plane (System-Assigned Identity)** to pull images from ACR
# This block remains correct as it uses the original System-Assigned Identity
# Role Assignment to allow AKS Nodes (kubelet identity) to pull images from ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = var.acr_resource_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  depends_on           = [azurerm_kubernetes_cluster.aks]
}