terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-infrap-bootstrap"
    storage_account_name = "stinfrapilottf"
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

module "app_service" {
  source              = "../../../terraform/modules/app_service"
  project             = var.project
  deployment_type     = var.deployment_type
  environment         = var.environment
  location            = var.location
  resource_group_name = module.resource_group.name
  service_plan_id     = module.app_service_plan.id
  django_secret_key   = var.django_secret_key
}
