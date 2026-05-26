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
