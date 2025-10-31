# 1) Existing VNet
data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
}

# 2) Existing AKS subnet
data "azurerm_subnet" "aks_snet" {
  name                 = var.aks_snet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name
}

# 3) AzureFirewallSubnet (/26 or larger)
resource "azurerm_subnet" "afw_snet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [local.firewall_snet_cidr] # e.g., "10.0.1.0/26"
}

# 4) Public IP (Standard, Static)
resource "azurerm_public_ip" "afw_pip" {
  name                = var.firewall_pip_name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  lifecycle {
    create_before_destroy = true
  }
}

# 5) Azure Firewall
resource "azurerm_firewall" "afw" {
  name                = local.firewall_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_tier            = "Standard"
  sku_name            = "AZFW_VNet"
  threat_intel_mode   = "Alert"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.afw_snet.id
    public_ip_address_id = azurerm_public_ip.afw_pip.id
  }

  timeouts {
    create = "1h"
    update = "1h"
    delete = "1h"
  }
}

# 6) Route table (no inline routes)
resource "azurerm_route_table" "rt" {
  name                          = local.route_table_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = false
}

# 6a) Default route to firewall (explicit depends_on)
resource "azurerm_route" "aks_egress_to_afw" {
  name                   = "aks-egress-to-afw"
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.rt.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.afw.ip_configuration[0].private_ip_address

  depends_on = [
    azurerm_firewall.afw,
    azurerm_public_ip.afw_pip,
    azurerm_subnet.afw_snet
  ]
}

resource "azurerm_route" "aks_to_fw_pip_inet" {
  name                = "to-fw-pip-internet"
  resource_group_name = var.resource_group_name
  route_table_name    = azurerm_route_table.rt.name

  # /32 for the firewall's PUBLIC IP
  # azurerm_public_ip.afw_pip.ip_address is known after creation
  address_prefix = "${azurerm_public_ip.afw_pip.ip_address}/32"

  # Send directly to the Internet to prevent asymmetric return path
  next_hop_type = "Internet"

  depends_on = [
    azurerm_public_ip.afw_pip,
    azurerm_route_table.rt
  ]
}

# 7) Associate RT to AKS subnet
# NOTE: If AKS is Azure CNI and owns its RT, consider updating that RT instead of associating a new one.
resource "azurerm_subnet_route_table_association" "aks_snet_rt_assoc" {
  subnet_id      = data.azurerm_subnet.aks_snet.id
  route_table_id = azurerm_route_table.rt.id
  depends_on = [
    azurerm_route_table.rt,
    azurerm_route.aks_egress_to_afw
  ]
}

# 8) NAT rule: inbound to NGINX (port 80)
resource "azurerm_firewall_nat_rule_collection" "nat_rc" {
  name                = local.nat_rc_name
  azure_firewall_name = azurerm_firewall.afw.name
  resource_group_name = var.resource_group_name
  priority            = 100
  action              = "Dnat"

  rule {
    name                  = "nginx-inbound-http"
    source_addresses      = ["*"]
    destination_addresses = [azurerm_public_ip.afw_pip.ip_address]
    destination_ports     = ["80"]
    protocols             = ["TCP"]
    translated_address    = var.aks_loadbalancer_ip
    translated_port       = "80"
  }
}

# 9) Network rules: DNS & NTP (example via locals)
resource "azurerm_firewall_network_rule_collection" "net_rc" {
  name                = local.net_rc_name
  azure_firewall_name = azurerm_firewall.afw.name
  resource_group_name = var.resource_group_name
  priority            = 200
  action              = "Allow"

  dynamic "rule" {
    for_each = local.network_rules
    content {
      name                  = rule.value.name
      source_addresses      = rule.value.source_addresses
      destination_addresses = rule.value.destination_addresses
      destination_ports     = rule.value.destination_ports
      protocols             = rule.value.protocols
    }
  }
}

# 10) App rules: explicit AKS dependencies
resource "azurerm_firewall_application_rule_collection" "app_rc" {
  name                = local.app_rc_name
  azure_firewall_name = azurerm_firewall.afw.name
  resource_group_name = var.resource_group_name
  priority            = 300
  action              = "Allow"

  rule {
    name             = "aks-required-fqdns"
    source_addresses = [var.aks_snet_address_prefix]
    target_fqdns = [
      "mcr.microsoft.com",
      "*.core.windows.net",
      "*.azurecr.io",
      "*.azk8s.io"
    ]
    protocol {
      type = "Https"
      port = 443
    }
    protocol {
      type = "Http"
      port = 80
    }
  }
}

# 10a) App rules: AKS FQDN tag (optional but recommended)
resource "azurerm_firewall_application_rule_collection" "app_rc_aks_tag" {
  name                = "${local.app_rc_name}-aks-tag"
  azure_firewall_name = azurerm_firewall.afw.name
  resource_group_name = var.resource_group_name
  priority            = 290
  action              = "Allow"

  rule {
    name             = "aks-fqdn-tag"
    source_addresses = [var.aks_snet_address_prefix]
    fqdn_tags        = ["AzureKubernetesService"]

  }
}