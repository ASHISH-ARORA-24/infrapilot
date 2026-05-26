terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-wings-bootstrap"
    storage_account_name = "stwingstf"
    container_name       = "tfstate"
    key                  = "aas_qa.tfstate"
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.subscription_id
}

provider "random" {}

module "resource_group" {
  source          = "../../../terraform/modules/resource_group"
  project         = var.project
  deployment_type = var.deployment_type
  environment     = var.environment
  location        = var.location
}

module "app_service_plan" {
  source              = "../../../terraform/modules/app_service_plan"
  project             = var.project
  deployment_type     = var.deployment_type
  environment         = var.environment
  location            = var.location
  resource_group_name = module.resource_group.name
}

module "postgresql" {
  source              = "../../../terraform/modules/postgresql"
  project             = var.project
  deployment_type     = var.deployment_type
  environment         = var.environment
  location            = var.location
  resource_group_name = module.resource_group.name
}

module "keyvault" {
  source              = "../../../terraform/modules/keyvault"
  project             = var.project
  deployment_type     = var.deployment_type
  environment         = var.environment
  location            = var.location
  resource_group_name = module.resource_group.name
  django_secret_key   = var.django_secret_key
  db_admin_password   = module.postgresql.admin_password
}

module "app_service" {
  source              = "../../../terraform/modules/app_service"
  project             = var.project
  deployment_type     = var.deployment_type
  environment         = var.environment
  location            = var.location
  resource_group_name = module.resource_group.name
  service_plan_id     = module.app_service_plan.id
  key_vault_name      = module.keyvault.name
  db_host             = module.postgresql.host
  db_name             = module.postgresql.database_name
  db_user             = module.postgresql.admin_username
}

resource "azurerm_key_vault_access_policy" "app_service" {
  key_vault_id = module.keyvault.id
  tenant_id    = module.keyvault.tenant_id
  object_id    = module.app_service.principal_id

  secret_permissions = ["Get", "List"]
}

resource "azurerm_key_vault_access_policy" "app_service_staging" {
  key_vault_id = module.keyvault.id
  tenant_id    = module.keyvault.tenant_id
  object_id    = module.app_service.staging_principal_id

  secret_permissions = ["Get", "List"]
}
