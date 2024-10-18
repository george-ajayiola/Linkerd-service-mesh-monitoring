variable "env" {
  description = "The environment name"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "The Azure region"
  type        = string
  default     = "eastus2"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "tutorial-terraform"
}

variable "aks_name" {
  description = "The name of the AKS cluster"
  type        = string
  default     = "demo"
}

variable "aks_version" {
  description = "The version of the EKS cluster"
  type        = string
  default     = "1.29.7"
}
