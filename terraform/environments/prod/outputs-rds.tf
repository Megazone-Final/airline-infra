output "rds_cluster_endpoint" {
  description = "The primary endpoint for the RDS Cluster"
  value       = module.rds.cluster_endpoint
}

output "rds_reader_endpoint" {
  description = "The reader endpoint for the RDS Cluster"
  value       = module.rds.cluster_reader_endpoint
}

output "rds_proxy_endpoint" {
  description = "The endpoint for the DB Proxy"
  value       = module.rds.proxy_endpoint
}
