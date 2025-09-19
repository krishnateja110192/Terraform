resource_groups = {
  rg1 = {
    name     = "cmaz-ey1bz94q-mod5-rg-01"
    location = "West Europe"
  },
  rg2 = {
    name     = "cmaz-ey1bz94q-mod5-rg-02"
    location = "North Europe"
  },
  rg3 = {
    name     = "cmaz-ey1bz94q-mod5-rg-03"
    location = "UK South"
  }
}

app_service_plans = {
  asp1 = {
    name         = "cmaz-ey1bz94q-mod5-asp-01"
    location_key = "rg1"
    worker_count = 2
    sku_name     = "S1"
    os_type      = "Windows"
  },
  asp2 = {
    name         = "cmaz-ey1bz94q-mod5-asp-02"
    location_key = "rg2"
    worker_count = 1
    sku_name     = "S1"
    os_type      = "Windows"
  }
}

app_services = {
  app1 = {
    name                 = "cmaz-ey1bz94q-mod5-app-01"
    location_key         = "rg1"
    app_service_plan_key = "asp1"
  },
  app2 = {
    name                 = "cmaz-ey1bz94q-mod5-app-02"
    location_key         = "rg2"
    app_service_plan_key = "asp2"
  }
}

traffic_manager_profile = {
  name               = "cmaz-ey1bz94q-mod5-traf"
  resource_group_key = "rg3"
  routing_method     = "Performance"
}

common_tags = {
  Creator = "krishnateja_samudrala@epam.com"
}

verification_agent_ip = "18.153.146.156"

ip_restriction_rules = [
  {
    name        = "allow-ip"
    priority    = 100
    action      = "Allow"
    ip_address  = "18.153.146.156/32"
    service_tag = null
  },
  {
    name        = "allow-tm"
    priority    = 200
    action      = "Allow"
    ip_address  = null
    service_tag = "AzureTrafficManager"
  }
]