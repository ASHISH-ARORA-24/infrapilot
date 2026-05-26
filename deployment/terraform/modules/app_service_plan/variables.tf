variable "project" {
  description = "Short project name used in resource naming"
  type        = string
  default     = "wings"
}

variable "deployment_type" {
  description = "Deployment type (aas, aca, aks, avm)"
  type        = string
}

variable "environment" {
  description = "Environment (sandbox, dev, qa, prod)"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group to deploy into"
  type        = string
}

variable "sku_name" {
  description = "App Service Plan SKU (e.g. B1, B2, P1v3)"
  type        = string
  default     = "S1"
}
