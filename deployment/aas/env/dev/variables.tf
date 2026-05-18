variable "project" {
  description = "Short project name used in resource naming"
  type        = string
  default     = "infrap"
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}
