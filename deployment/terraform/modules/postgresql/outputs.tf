output "host" {
  description = "PostgreSQL server FQDN"
  value       = azurerm_postgresql_flexible_server.this.fqdn
}

output "database_name" {
  description = "Database name"
  value       = azurerm_postgresql_flexible_server_database.this.name
}

output "admin_username" {
  description = "Admin username"
  value       = azurerm_postgresql_flexible_server.this.administrator_login
}

output "admin_password" {
  description = "Admin password"
  value       = random_password.admin.result
  sensitive   = true
}
