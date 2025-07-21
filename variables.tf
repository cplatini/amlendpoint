variable "prefix" {
  description = "Naming prefix"
  type        = string
  default     = "acme"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Name of RG to create/use"
  type        = string
  default     = "rg-${var.prefix}-ml"
}

variable "workspace_sku" {
  description = "SKU for Azure ML workspace"
  type        = string
  default     = "Enterprise"
}

variable "storage_sku" {
  description = "Storage account SKU"
  type        = string
  default     = "Standard_LRS"
}

variable "enable_private_link" {
  description = "Whether to enable Private Link for workspace storage"
  type        = bool
  default     = true
}

