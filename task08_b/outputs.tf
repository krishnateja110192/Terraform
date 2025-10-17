# Replace with the actual exported output name from your aci_redis module
output "redis_fqdn" {
  description = "FQDN of the Redis ACI endpoint."
  value       = module.aci_redis.fqdn
}


output "aca_fqdn" {
  description = "Stable ingress FQDN for the Azure Container App."
  value       = module.aca.fqdn
}


output "aks_lb_ip" {
  description = "The Load Balancer IP address of the App in AKS."
  value       = module.k8s.lb_ip
}