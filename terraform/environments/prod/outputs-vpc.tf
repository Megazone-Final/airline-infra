output "vpc_id" {
  description = "ID of the shared VPC."
  value       = module.vpc.id
}

output "vpc_secondary_cidr_block" {
  description = "Secondary CIDR block associated with the shared VPC."
  value       = module.vpc.secondary_cidr_block
}

output "nat_gateway_id" {
  description = "ID of the shared regional NAT Gateway."
  value       = module.vpc.nat_gateway_id
}

output "private_subnet_ids" {
  description = "Private subnet IDs for application workloads."
  value       = module.vpc.private_subnet_ids
}

output "public_subnet_ids" {
  description = "Public subnet IDs for ingress and public endpoints."
  value       = module.vpc.public_subnet_ids
}

output "node_private_subnet_ids" {
  description = "Private subnet IDs intended for node workloads."
  value       = module.vpc.node_private_subnet_ids
}

output "db_private_subnet_ids" {
  description = "Private subnet IDs intended for database workloads."
  value       = module.vpc.db_private_subnet_ids
}

output "pod_private_subnet_ids" {
  description = "Private subnet IDs intended for pod workloads."
  value       = module.vpc.pod_private_subnet_ids
}

output "route_table_ids" {
  description = "Route table IDs grouped by traffic role."
  value       = module.vpc.route_table_ids
}
