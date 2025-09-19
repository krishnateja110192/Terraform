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

#App Service Plan parameters.
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

#App Service parameters.
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

#Traffic Manager profile parameters.
traffic_manager_profile = {
  name               = "cmaz-ey1bz94q-mod5-traf"
  resource_group_key = "rg3"
  routing_method     = "Performance"
}

#Verification agent IP address.
verification_agent_ip = "18.153.146.156"

#Common tags.
common_tags = {
  Creator = "krishnateja_samudrala@epam.com"
}