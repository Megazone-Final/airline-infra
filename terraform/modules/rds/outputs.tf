output "cluster_id" {
  description = "The ID of the RDS Cluster"
  value       = aws_rds_cluster.main.id
}

output "cluster_endpoint" {
  description = "The primary endpoint for the RDS Cluster"
  value       = aws_rds_cluster.main.endpoint
}

output "cluster_reader_endpoint" {
  description = "The reader endpoint for the RDS Cluster"
  value       = aws_rds_cluster.main.reader_endpoint
}

output "primary_instance_id" {
  description = "The ID of the primary DB instance"
  value       = aws_rds_cluster_instance.primary.id
}

output "reader_instance_id" {
  description = "The ID of the reader DB instance"
  value       = aws_rds_cluster_instance.reader.id
}

output "proxy_id" {
  description = "The ID of the DB Proxy"
  value       = aws_db_proxy.proxy.id
}

output "proxy_endpoint" {
  description = "The endpoint for the DB Proxy"
  value       = aws_db_proxy.proxy.endpoint
}

output "db_subnet_group_id" {
  description = "The ID of the DB Subnet Group"
  value       = aws_db_subnet_group.subnet_group.id
}
