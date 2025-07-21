output "workspace_id" {
  value       = azurerm_machine_learning_workspace.amlws.id
  description = "The AML workspace resource ID"
}

output "endpoint_scoring_uri" {
  value       = azurerm_machine_learning_online_endpoint.endpoint.scoring_uri
  description = "The scoring URI for the managed endpoint"
}

