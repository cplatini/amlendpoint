variable "prefix" {
  description = "Naming prefix"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "sku" {
  description = "AML Workspace SKU"
  type        = string
}

variable "storage_sku" {
  description = "Storage SKU"
  type        = string
}

variable "private_subnet_id" {
  description = "Subnet ID for private endpoints"
  type        = string
}

variable "model_id" {
  description = "ID of the registered ML model in Azure ML"
  type        = string
}

