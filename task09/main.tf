# task09/main.tf

# Module call to deploy and configure Azure Firewall
module "azure_firewall" {
  source                  = "./modules/afw"
  resource_group_name     = var.resource_group_name
  location                = var.location
  vnet_name               = var.vnet_name
  vnet_address_space      = var.vnet_address_space
  aks_snet_name           = var.aks_snet_name
  aks_snet_address_prefix = var.aks_snet_address_prefix
  naming_prefix           = local.naming_prefix
  aks_loadbalancer_ip     = var.aks_loadbalancer_ip
  firewall_pip_name       = var.firewall_pip_name
}