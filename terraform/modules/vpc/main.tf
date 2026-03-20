resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(var.tags, {
    Name = local.names.vpc
  })
}

resource "aws_vpc_ipv4_cidr_block_association" "pod" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.pod_secondary_cidr
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = local.names.igw
  })
}

resource "aws_subnet" "primary" {
  for_each = local.primary_subnets

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch

  tags = merge(var.tags, each.value.additional_tags, {
    Name = each.value.name
    Tier = each.value.tier
    Role = each.value.role
  })
}

resource "aws_nat_gateway" "regional" {
  availability_mode = "regional"
  connectivity_type = "public"
  vpc_id            = aws_vpc.this.id
  depends_on        = [aws_internet_gateway.this]

  tags = merge(var.tags, {
    Name = local.names.nat
  })
}

resource "aws_subnet" "pod" {
  for_each = local.pod_subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  depends_on        = [aws_vpc_ipv4_cidr_block_association.pod]

  tags = merge(var.tags, each.value.additional_tags, {
    Name = each.value.name
    Tier = each.value.tier
    Role = each.value.role
  })
}
