data "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = "rg-infrap-bootstrap"
}

resource "azurerm_linux_web_app" "this" {
  name                = "app-${var.project}-${var.deployment_type}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.service_plan_id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    container_registry_use_managed_identity = true

    application_stack {
      docker_image_name        = "${var.image_name}:${var.image_tag}"
      docker_registry_url      = "https://${data.azurerm_container_registry.acr.login_server}"
      docker_registry_username = null
      docker_registry_password = null
    }
  }

  app_settings = {
    WEBSITES_PORT   = "8000"
    DEPLOYMENT_TYPE = var.deployment_type
    SECRET_KEY      = var.django_secret_key
    ALLOWED_HOSTS   = "app-${var.project}-${var.deployment_type}-${var.environment}.azurewebsites.net"
  }

  tags = {
    project         = "infrapilot"
    deployment_type = var.deployment_type
    environment     = var.environment
  }
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_linux_web_app.this.identity[0].principal_id
}
