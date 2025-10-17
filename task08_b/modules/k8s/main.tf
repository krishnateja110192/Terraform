

# Template for SecretProviderClass
data "template_file" "secret_provider" {
  template = file("${path.module}/../../k8s-manifests/secret-provider.yaml.tftpl")

  vars = {
    aks_kv_access_identity_id  = var.aks_kv_access_identity_id
    kv_name                    = var.kv_name
    redis_url_secret_name      = var.redis_url_secret_name
    redis_password_secret_name = var.redis_password_secret_name
    tenant_id                  = var.tenant_id
  }
}

# Deploy SecretProviderClass
resource "kubectl_manifest" "secret_provider" {
  yaml_body = data.template_file.secret_provider.rendered

}

# Template for Deployment
data "template_file" "deployment" {
  template = file("${path.module}/../../k8s-manifests/deployment.yaml.tftpl")

  vars = {
    acr_login_server = var.acr_login_server
    app_image_name   = var.app_image_name
    image_tag        = var.image_tag
  }
}

# Deploy Deployment
resource "kubectl_manifest" "deployment" {
  yaml_body = data.template_file.deployment.rendered
  depends_on = [
    kubectl_manifest.secret_provider # SecretProviderClass must be present
  ]

  # Wait for deployment to be ready
  wait_for {
    field {
      key   = "status.availableReplicas"
      value = "1"
    }
  }
}

# Deploy Service (LoadBalancer)
resource "kubectl_manifest" "service" {
  yaml_body = file("${path.module}/../../k8s-manifests/service.yaml")
  depends_on = [
    kubectl_manifest.deployment # Ensure deployment is done before service is exposed
  ]

  # Wait for LoadBalancer IP
  wait_for {
    field {
      key        = "status.loadBalancer.ingress.[0].ip"
      value      = "^(\\d+(\\.|$)){4}"
      value_type = "regex"
    }
  }
}

# Data source to access information about deployed Kubernetes service to get LoadBalancer IP address
data "kubernetes_service" "app_service" {
  metadata {
    name      = "redis-flask-app-service"
    namespace = "default" # Assuming default namespace
  }
  depends_on = [kubectl_manifest.service]
}