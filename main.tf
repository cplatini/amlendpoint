terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# =====================
# 1) Infrastructure as Code & Automation
# =====================

module "aml" {
  source              = "./modules/aml_workspace"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.workspace_sku
  storage_sku         = var.storage_sku
  enable_private_link = var.enable_private_link
}

# =====================
# 2) CI/CD Pipeline Design
# =====================
# In Azure DevOps or GitHub Actions, you would:
# - Checkout this repo (main branch → dev env; release branch → prod)
# - Run `terraform init` and `terraform plan -var-file=env/dev.tfvars`
# - On approval, `terraform apply -var-file=env/dev.tfvars`
# - Use service principals with least-privilege in pipeline.

