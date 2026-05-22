variable "project" {
  description = "Short project name used in resource naming"
  type        = string
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

variable "django_secret_key" {
  description = "Django SECRET_KEY"
  type        = string
  sensitive   = true
}

variable "db_admin_password" {
  description = "PostgreSQL admin password"
  type        = string
  sensitive   = true
}
