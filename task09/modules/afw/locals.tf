locals {
  # Resource Naming Convention: cmtr-ey1bz94q-mod9-**resource-abbreviation**
  firewall_snet_name = "${var.naming_prefix}-snet-afw" # snet-afw for AzureFirewallSubnet
  firewall_name      = "${var.naming_prefix}-afw"      # afw for Azure Firewall
  route_table_name   = "${var.naming_prefix}-rt"       # rt for Route Table

  # Rule collection names
  nat_rc_name             = "nat-rc-nginx-inbound"
  app_rc_name             = "app-rc-aks-egress"
  net_rc_name             = "net-rc-aks-egress"
  app_rc_aks_tag_name     = "${local.app_rc_name}-aks-tag"
  aks_egress_to_afw_name  = "aks-egress-to-afw"
  aks_to_fw_pip_inet_name = "to-fw-pip-internet"

  # Firewall Subnet address space (must be /26 or larger within the VNet)
  firewall_snet_address_prefix = cidrsubnet(var.vnet_address_space, 8, 1)             # e.g., 10.0.1.0/24 if VNET is 10.0.0.0/16
  firewall_snet_cidr           = cidrsubnet(local.firewall_snet_address_prefix, 2, 0) # e.g., 10.0.1.0/26

  network_rules = [
    {
      name                  = "allow-dns"
      source_addresses      = [var.aks_snet_address_prefix]
      protocols             = ["UDP", "TCP"]
      destination_ports     = ["53"]
      destination_addresses = ["168.63.129.16"]
    },
    {
      name                  = "allow-ntp"
      source_addresses      = [var.aks_snet_address_prefix]
      protocols             = ["UDP"]
      destination_ports     = ["123"]
      destination_addresses = ["0.0.0.0/0"]
    }
  ]


}
