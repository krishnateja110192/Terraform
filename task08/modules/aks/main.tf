resource "azurerm_kubernetes_cluster" "main" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.aks_name
  tags                = var.tags

  # 1. Corrected default_node_pool block
  default_node_pool {
    name         = var.default_node_pool_name
    node_count   = var.default_node_pool_count
    vm_size      = var.default_node_pool_vm_size
    os_disk_type = var.default_node_pool_os_disk_type
    # Removed 'enable_auto_scaling' - it's not supported in this schema version
  }

  identity {
    type = "SystemAssigned"
  }

  # 2. Corrected key_vault_secrets_provider block
  # Using the presence of the block to enable the CSI driver (as 'enabled' is unexpected)
  key_vault_secrets_provider {
    # FIX: Explicitly disable secret rotation to satisfy the required argument check.
    secret_rotation_enabled = false
  }


  # 3. Role-Based Access Control
  # Removed the entire 'role_based_access_control' block. 
  # RBAC is typically enabled by default and the AAD managed options are defined
  # inside a separate 'azure_active_directory_role_based_access_control' block 
  # or not needed if we rely on the default settings.

  # Minimal service principal definition (usually required even with managed identity for control plane)
  # Since we are using SystemAssigned Identity, we can omit the explicit service_principal block.
}

# Role Assignment to allow AKS's System Identity to pull images from ACR
resource "azurerm_role_assignment" "acr_pull" {
  scope                            = var.acr_id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_kubernetes_cluster.main.identity[0].principal_id
  skip_service_principal_aad_check = true
  depends_on                       = [azurerm_kubernetes_cluster.main]
}

# Key Vault Access Policy to allow AKS Kubelet Identity to get secrets (for CSI driver)
# Note: Kubelet identity is used by the CSI driver to access Key Vault
resource "azurerm_key_vault_access_policy" "aks_kubelet_secrets_get" {
  key_vault_id = var.key_vault_id
  tenant_id    = azurerm_kubernetes_cluster.main.identity[0].tenant_id
  object_id    = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id

  secret_permissions = [
    "Get",
  ]
  depends_on = [azurerm_kubernetes_cluster.main]
}

# Key Vault Access Policy to allow AKS Kubelet Identity to list secrets
resource "azurerm_key_vault_access_policy" "aks_kubelet_secrets_list" {
  key_vault_id = var.key_vault_id
  tenant_id    = azurerm_kubernetes_cluster.main.identity[0].tenant_id
  object_id    = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id

  secret_permissions = [
    "List",
  ]
  depends_on = [azurerm_kubernetes_cluster.main]
}