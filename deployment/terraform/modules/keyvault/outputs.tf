output "id" {
  description = "Key Vault ID"
  value       = azurerm_key_vault.this.id
}

output "name" {
  description = "Key Vault name"
  value       = azurerm_key_vault.this.name
}

output "tenant_id" {
  description = "Tenant ID"
  value       = data.azurerm_client_config.current.tenant_id
}
