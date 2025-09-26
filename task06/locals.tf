locals {
  rg_name         = format("%s-%s", var.name_prefix, "rg")
  sql_server_name = format("%s-%s", var.name_prefix, "sql")
  sql_db_name     = format("%s-%s-%s", var.name_prefix, "sql", "db")
  asp_name        = format("%s-%s", var.name_prefix, "asp")
  app_name        = format("%s-%s", var.name_prefix, "app")
  location        = var.location
}
