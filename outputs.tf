output "aml_workspace_id" {
  description = "The resource ID of the Azure ML Workspace"
  value       = module.aml.workspace_id
}

output "aml_endpoint_url" {
  description = "The scoring URI for the managed online endpoint"
  value       = module.aml.endpoint_scoring_uri
}

