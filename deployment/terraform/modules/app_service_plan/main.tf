resource "azurerm_service_plan" "this" {
  name                = "asp-${var.project}-${var.deployment_type}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = var.sku_name

  tags = {
    project         = var.project
    deployment_type = var.deployment_type
    environment     = var.environment
  }

  timeouts {
    create = "30m"
  }
}
