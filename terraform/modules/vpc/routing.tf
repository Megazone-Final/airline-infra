resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(var.tags, {
    Name = local.names.rt_public
    Tier = "public"
  })
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.regional.id
  }

  tags = merge(var.tags, {
    Name = local.names.rt_private
    Tier = "private"
    Role = "node"
  })
}

resource "aws_route_table" "db_private" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = local.names.rt_db_private
    Tier = "private"
    Role = "db"
  })
}

resource "aws_route_table" "pod_private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.regional.id
  }

  tags = merge(var.tags, {
    Name = local.names.rt_pod_private
    Tier = "private"
    Role = "pod"
  })
}

resource "aws_route_table_association" "primary" {
  for_each = local.primary_subnets

  subnet_id      = aws_subnet.primary[each.key].id
  route_table_id = each.value.route_table == "public" ? aws_route_table.public.id : (
    each.value.route_table == "db_private" ? aws_route_table.db_private.id : aws_route_table.private.id
  )
}

resource "aws_route_table_association" "pod" {
  for_each = local.pod_subnets

  subnet_id      = aws_subnet.pod[each.key].id
  route_table_id = aws_route_table.pod_private.id
}
