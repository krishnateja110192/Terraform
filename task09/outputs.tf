# task09/outputs.tf

# Requirement: Azure Firewall Public IP address
output "azure_firewall_public_ip" {
  description = "The Public IP address of the Azure Firewall."
  value       = module.azure_firewall.azure_firewall_public_ip
}

# Requirement: Azure Firewall Private IP address
output "azure_firewall_private_ip" {
  description = "The Private IP address of the Azure Firewall."
  value       = module.azure_firewall.azure_firewall_private_ip
}