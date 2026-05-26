resource "random_password" "admin" {
  length  = 24
  special = false
}

resource "azurerm_postgresql_flexible_server" "this" {
  name                          = "psql-${var.project}-${var.deployment_type}-${var.environment}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  version                       = "16"
  administrator_login           = "psqladmin"
  administrator_password        = random_password.admin.result
  sku_name                      = "B_Standard_B1ms"
  storage_mb                    = 32768
  backup_retention_days         = 7
  geo_redundant_backup_enabled  = false

  tags = {
    project         = var.project
    deployment_type = var.deployment_type
    environment     = var.environment
  }
}

resource "azurerm_postgresql_flexible_server_database" "this" {
  name      = "wings"
  server_id = azurerm_postgresql_flexible_server.this.id
  collation = "en_US.utf8"
  charset   = "UTF8"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_postgresql_flexible_server.this.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
