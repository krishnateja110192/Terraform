locals {
  # Concatenate resource group name
  rg_name = "${var.name_prefix}-rg"

  # Concatenate SQL Server and Database names
  sql_server_name = "${var.name_prefix}-sql"
  sql_db_name     = "${var.name_prefix}-sql-db"

  # Concatenate App Service Plan and Web App names
  asp_name = "${var.name_prefix}-asp"
  app_name = "${var.name_prefix}-app"

  # Required location
  location = var.location
}