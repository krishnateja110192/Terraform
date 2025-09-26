output "sql_server_fqdn" {
  description = "Fully Qualified Domain Name of the SQL Server."
  value       = azurerm_mssql_server.sql_server.fully_qualified_domain_name
}

output "sql_server_name" {
  description = "The name of the SQL Server."
  value       = azurerm_mssql_server.sql_server.name
}

output "sql_db_name" {
  description = "The name of the SQL Database."
  value       = azurerm_mssql_database.sql_db.name
}

# Sensitive output: ADO.NET connection string with SQL authentication
output "sql_connection_string" {
  description = "The ADO.NET connection string for the SQL Database using SQL authentication."
  value = format(
    "Server=tcp:%s,1433;Initial Catalog=%s;Persist Security Info=False;User ID=%s;Password=%s;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;",
    azurerm_mssql_server.sql_server.fully_qualified_domain_name,
    azurerm_mssql_database.sql_db.name,
    var.sql_admin_username,
    random_password.sql_admin_password.result
  )
  sensitive = true
}
