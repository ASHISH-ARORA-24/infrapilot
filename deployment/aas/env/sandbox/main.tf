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
    key                  = "aas_sandbox.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

module "resource_group" {
  source          = "../../../terraform/modules/resource_group"
  project         = var.project
  deployment_type = "aas"
  environment     = "sandbox"
  location        = var.location
}

module "app_service_plan" {
  source              = "../../../terraform/modules/app_service_plan"
  project             = var.project
  deployment_type     = "aas"
  environment         = "sandbox"
  location            = var.location
  resource_group_name = module.resource_group.name
}
