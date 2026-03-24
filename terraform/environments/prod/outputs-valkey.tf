output "valkey_session_primary_endpoint" {
  description = "Primary endpoint address for the session Valkey cluster."
  value       = module.valkey.session_primary_endpoint
}

output "valkey_svc_primary_endpoint" {
  description = "Primary endpoint address for the backend SVC Valkey cluster (IAM authentication)."
  value       = module.valkey.svc_primary_endpoint
}
