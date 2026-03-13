output "vpc_id" {
  description = "VPC ID."
  value       = try(aws_vpc.this[0].id, null)
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = var.enabled ? [for az in sort(keys(local.public_subnets_by_az)) : aws_subnet.public[az].id] : []
}

output "private_subnet_ids" {
  description = "Private subnet IDs."
  value       = var.enabled ? [for az in sort(keys(local.private_subnets_by_az)) : aws_subnet.private[az].id] : []
}

output "internet_gateway_id" {
  description = "Internet gateway ID."
  value       = try(aws_internet_gateway.this[0].id, null)
}

output "nat_gateway_id" {
  description = "NAT gateway ID when enabled."
  value       = try(aws_nat_gateway.this[0].id, null)
}
