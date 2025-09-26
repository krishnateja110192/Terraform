name_prefix                   = "cmaz-ey1bz94q-mod6"
key_vault_rg_name             = "cmaz-ey1bz94q-mod6-kv-rg"
key_vault_name                = "cmaz-ey1bz94q-mod6-kv"
sql_admin_name_secret         = "sql-admin-name"
sql_admin_password_secret     = "sql-admin-password"
allowed_ip_address            = "18.153.146.156" # Verification agent IP
sql_azure_fw_rule_name        = "AllowAzureServices"
sql_verification_fw_rule_name = "allow-verification-ip"
sql_db_sku                    = "S2"
app_service_plan_sku          = "P0v3"
app_service_os                = "Linux"
webapp_dotnet_version         = "8.0"
local_ip_address              = "152.59.199.173"
local_ip_name                 = "allow-local-ip"



tags = {
  Creator = "krishnateja_samudrala@epam.com"
}
