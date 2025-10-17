output "lb_ip" {
  description = "The Load Balancer IP address of the AKS application service."
  value       = data.kubernetes_service.app_service.status.0.load_balancer.0.ingress.0.ip
}
