# Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Storage Account (geo-redundant)
resource "azurerm_storage_account" "sa" {
  name                     = "${var.prefix}mlsa"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

# Key Vault
resource "azurerm_key_vault" "kv" {
  name                = "${var.prefix}-kv"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  soft_delete_enabled = true

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = ["get", "list"]
  }
}

# Azure ML Workspace
resource "azurerm_machine_learning_workspace" "amlws" {
  name                = "${var.prefix}-aml"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_name            = var.sku

  storage_account_id     = azurerm_storage_account.sa.id
  key_vault_id           = azurerm_key_vault.kv.id
  application_insights_id = azurerm_application_insights.ai.id
  identity {
    type = "SystemAssigned"
  }

  # Private endpoint for network isolation
  private_endpoint {
    name      = "${var.prefix}-aml-pe"
    subnet_id = var.private_subnet_id
  }
}

# App Insights for Monitoring
resource "azurerm_application_insights" "ai" {
  name                = "${var.prefix}-ai"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "Other"
}

# Managed online endpoint + deployment
resource "azurerm_machine_learning_online_endpoint" "endpoint" {
  name                = "${var.prefix}-endpoint"
  resource_group_name = azurerm_resource_group.rg.name
  workspace_name      = azurerm_machine_learning_workspace.amlws.name
  identity {
    type = "SystemAssigned"
  }
  auth_mode = "Key"
}

resource "azurerm_machine_learning_online_deployment" "deploy" {
  name                 = "blue"
  endpoint_name        = azurerm_machine_learning_online_endpoint.endpoint.name
  resource_group_name  = azurerm_resource_group.rg.name
  workspace_name       = azurerm_machine_learning_workspace.amlws.name
  model_id             = var.model_id
  instance_type        = "Standard_DS3_v2"
  instance_count       = 2

  # Autoscale settings
  autoscale {
    min_replicas = 1
    max_replicas = 5
    target_utilization {
      metric_name = "cpu"
      target      = 70
    }
  }

  rollout_mode = "Incremental"
  traffic {
    blue = 100
  }
}

