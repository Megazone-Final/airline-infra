output "session_primary_endpoint" {
  description = "Primary endpoint address for the session Valkey cluster."
  value       = aws_elasticache_replication_group.valkey-an2-airline-session.primary_endpoint_address
}

output "session_reader_endpoint" {
  description = "Reader endpoint address for the session Valkey cluster."
  value       = aws_elasticache_replication_group.valkey-an2-airline-session.reader_endpoint_address
}

output "svc_primary_endpoint" {
  description = "Primary endpoint address for the backend SVC Valkey cluster (IAM authentication)."
  value       = aws_elasticache_replication_group.valkey-an2-airline-svc.primary_endpoint_address
}

output "svc_reader_endpoint" {
  description = "Reader endpoint address for the backend SVC Valkey cluster (IAM authentication)."
  value       = aws_elasticache_replication_group.valkey-an2-airline-svc.reader_endpoint_address
}
