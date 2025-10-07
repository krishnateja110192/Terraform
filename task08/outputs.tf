output "aks_lb_ip" {
  description = "Load Balancer IP address of APP in AKS."
  # Corrected path to access the Load Balancer IP
  value = data.kubernetes_service.app_service.status.0.load_balancer.0.ingress.0.ip
}

# The rest of outputs.tf remains the same:
output "aci_fqdn" {
  description = "FQDN of App in Azure Container Instance."
  value       = module.aci.aci_fqdn
}