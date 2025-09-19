output "traffic_manager_fqdn" {
  value       = module.traffic_manager.fqdn
  description = "The FQDN of the Azure Traffic Manager Profile."
}