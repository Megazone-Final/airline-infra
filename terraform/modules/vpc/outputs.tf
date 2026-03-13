output "id" {
  description = "ID of the VPC."
  value       = aws_vpc.this.id
}

output "arn" {
  description = "ARN of the VPC."
  value       = aws_vpc.this.arn
}

output "cidr_block" {
  description = "CIDR block of the VPC."
  value       = aws_vpc.this.cidr_block
}

output "secondary_cidr_block" {
  description = "Secondary CIDR block associated with the VPC."
  value       = aws_vpc_ipv4_cidr_block_association.pod.cidr_block
}

output "igw_id" {
  description = "Internet Gateway ID."
  value       = aws_internet_gateway.this.id
}

output "nat_gateway_id" {
  description = "Regional NAT gateway ID."
  value       = aws_nat_gateway.regional.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value = {
    for key in local.public_subnet_keys : key => aws_subnet.primary[key].id
  }
}

output "node_private_subnet_ids" {
  description = "Node private subnet IDs."
  value = {
    for key in local.node_private_subnet_keys : key => aws_subnet.primary[key].id
  }
}

output "db_private_subnet_ids" {
  description = "Database private subnet IDs."
  value = {
    for key in local.db_private_subnet_keys : key => aws_subnet.primary[key].id
  }
}

output "pod_private_subnet_ids" {
  description = "Pod private subnet IDs."
  value = {
    for key in local.pod_subnet_keys : key => aws_subnet.pod[key].id
  }
}

output "private_subnet_ids" {
  description = "Private subnet IDs."
  value = merge(
    {
      for key in local.node_private_subnet_keys : key => aws_subnet.primary[key].id
    },
    {
      for key in local.db_private_subnet_keys : key => aws_subnet.primary[key].id
    },
    {
      for key in local.pod_subnet_keys : key => aws_subnet.pod[key].id
    },
  )
}

output "route_table_ids" {
  description = "Route table IDs by type."
  value = {
    public      = aws_route_table.public.id
    private     = aws_route_table.private.id
    db_private  = aws_route_table.db_private.id
    pod_private = aws_route_table.pod_private.id
  }
}
