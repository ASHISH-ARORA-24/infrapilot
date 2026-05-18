resource "azurerm_resource_group" "this" {
  name     = "rg-${var.project}-${var.deployment_type}-${var.environment}"
  location = var.location

  tags = {
    project         = "infrapilot"
    deployment_type = var.deployment_type
    environment     = var.environment
  }
}
