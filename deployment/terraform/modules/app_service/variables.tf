variable "project" {
  description = "Short project name used in resource naming"
  type        = string
  default     = "infrap"
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

variable "service_plan_id" {
  description = "ID of the App Service Plan"
  type        = string
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "crinfrap"
}

variable "image_name" {
  description = "Container image name"
  type        = string
  default     = "infrapilot"
}

variable "image_tag" {
  description = "Container image tag"
  type        = string
  default     = "latest"
}

variable "django_secret_key" {
  description = "Django SECRET_KEY (used directly when key_vault_name is not set)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "key_vault_name" {
  description = "Key Vault name for secret references (leave empty to use direct values)"
  type        = string
  default     = ""
}

variable "db_host" {
  description = "PostgreSQL server FQDN"
  type        = string
  default     = ""
}

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = ""
}

variable "db_user" {
  description = "PostgreSQL admin username"
  type        = string
  default     = ""
}
