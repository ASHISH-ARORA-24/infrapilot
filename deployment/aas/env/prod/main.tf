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
    key                  = "aas_prod.tfstate"
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
  deployment_type = "aas"
  environment     = "prod"
  location        = var.location
}
