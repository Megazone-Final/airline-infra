output "vpc_id" {
  description = "ID of the created VPC."
  value       = module.vpc.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the created VPC."
  value       = module.vpc.cidr_block
}

output "vpc_secondary_cidr_block" {
  description = "Secondary CIDR block of the created VPC."
  value       = module.vpc.secondary_cidr_block
}

output "igw_id" {
  description = "Internet Gateway ID attached to the VPC."
  value       = module.vpc.igw_id
}

output "nat_gateway_id" {
  description = "Regional NAT Gateway ID."
  value       = module.vpc.nat_gateway_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs."
  value       = module.vpc.private_subnet_ids
}

output "route_table_ids" {
  description = "Route table IDs."
  value       = module.vpc.route_table_ids
}
