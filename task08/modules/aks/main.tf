resource "azurerm_kubernetes_cluster" "main" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.aks_name
  tags                = var.tags

  default_node_pool {
    name            = var.default_node_pool_name
    node_count      = var.default_node_pool_count
    vm_size         = var.default_node_pool_vm_size
    os_disk_type    = var.default_node_pool_os_disk_type
    os_disk_size_gb = var.default_node_pool_os_disk_size_gb
  }

  identity {
    type = "SystemAssigned"
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = false
  }
}

# Role assignment for ACR pull (kubelet identity)
resource "azurerm_role_assignment" "acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
  depends_on           = [azurerm_kubernetes_cluster.main]
}

# Single Key Vault access policy for kubelet identity
resource "azurerm_key_vault_access_policy" "aks_kubelet_secrets" {
  key_vault_id = var.key_vault_id
  tenant_id    = azurerm_kubernetes_cluster.main.identity[0].tenant_id
  object_id    = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id

  secret_permissions = ["Get", "List"]

  depends_on = [azurerm_kubernetes_cluster.main]


  lifecycle {
    create_before_destroy = true
  }

}