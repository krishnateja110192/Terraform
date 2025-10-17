location    = "East US"
name_prefix = "cmtr-ey1bz94q-mod8b"
tags = {
  Creator = "krishnateja_samudrala@epam.com"
}
acr_sku                             = "Basic"
acr_app_image_name                  = "cmtr-ey1bz94q-mod8b-app"
redis_aci_image                     = "mcr.microsoft.com/cbl-mariner/base/redis:6.2-cm2.0"
redis_aci_sku                       = "Standard"
sa_replication_type                 = "LRS"
sa_container_access_type            = "private"
aks_default_node_pool_count         = 1
aks_default_node_size               = "Standard_D2ads_v6"
aks_default_node_os_disk_type       = "Ephemeral"
aks_default_node_os_disk_size_gb    = 64
keyvault_sku_name                   = "standard"
keyvault_redis_password_secret_name = "redis-password"
keyvault_redis_hostname_secret_name = "redis-hostname"