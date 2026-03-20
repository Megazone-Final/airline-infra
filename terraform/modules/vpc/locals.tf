locals {
  names = {
    vpc            = join("-", ["vpc", var.region_code, var.project_name, "network", "main"])
    igw            = join("-", ["igw", var.region_code, var.project_name, "network", "main"])
    nat            = join("-", ["nat", var.region_code, var.project_name, "network", "regional"])
    rt_public      = join("-", ["rt", var.region_code, var.project_name, "edge", "pub"])
    rt_private     = join("-", ["rt", var.region_code, var.project_name, "shared", "pri"])
    rt_db_private  = join("-", ["rt", var.region_code, var.project_name, "db", "pri"])
    rt_pod_private = join("-", ["rt", var.region_code, var.project_name, "pod", "pri"])
  }

  alb_cluster_tag = var.alb_cluster_name == "" ? {} : {
    "kubernetes.io/cluster/${var.alb_cluster_name}" = "shared"
  }

  public_alb_tags = merge(local.alb_cluster_tag, {
    "kubernetes.io/role/elb" = "1"
  })

  private_alb_tags = merge(local.alb_cluster_tag, {
    "kubernetes.io/role/internal-elb" = "1"
  })

  subnet_definitions = {
    edge_public_2a = {
      cidr_block              = var.subnet_cidrs.edge_public_2a
      availability_zone       = var.azs["2a"]
      name                    = join("-", ["subnet", var.region_code, var.project_name, "edge", "pub-2a"])
      tier                    = "public"
      role                    = "edge"
      route_table             = "public"
      map_public_ip_on_launch = true
      requires_secondary_cidr = false
      additional_tags         = local.public_alb_tags
    }
    edge_public_2c = {
      cidr_block              = var.subnet_cidrs.edge_public_2c
      availability_zone       = var.azs["2c"]
      name                    = join("-", ["subnet", var.region_code, var.project_name, "edge", "pub-2c"])
      tier                    = "public"
      role                    = "edge"
      route_table             = "public"
      map_public_ip_on_launch = true
      requires_secondary_cidr = false
      additional_tags         = local.public_alb_tags
    }
    node_private_2a = {
      cidr_block              = var.subnet_cidrs.node_private_2a
      availability_zone       = var.azs["2a"]
      name                    = join("-", ["subnet", var.region_code, var.project_name, "node", "pri-2a"])
      tier                    = "private"
      role                    = "node"
      route_table             = "private"
      map_public_ip_on_launch = false
      requires_secondary_cidr = false
      additional_tags         = local.private_alb_tags
    }
    node_private_2c = {
      cidr_block              = var.subnet_cidrs.node_private_2c
      availability_zone       = var.azs["2c"]
      name                    = join("-", ["subnet", var.region_code, var.project_name, "node", "pri-2c"])
      tier                    = "private"
      role                    = "node"
      route_table             = "private"
      map_public_ip_on_launch = false
      requires_secondary_cidr = false
      additional_tags         = local.private_alb_tags
    }
    db_private_2a = {
      cidr_block              = var.subnet_cidrs.db_private_2a
      availability_zone       = var.azs["2a"]
      name                    = join("-", ["subnet", var.region_code, var.project_name, "db", "pri-2a"])
      tier                    = "private"
      role                    = "db"
      route_table             = "db_private"
      map_public_ip_on_launch = false
      requires_secondary_cidr = false
      additional_tags         = {}
    }
    db_private_2c = {
      cidr_block              = var.subnet_cidrs.db_private_2c
      availability_zone       = var.azs["2c"]
      name                    = join("-", ["subnet", var.region_code, var.project_name, "db", "pri-2c"])
      tier                    = "private"
      role                    = "db"
      route_table             = "db_private"
      map_public_ip_on_launch = false
      requires_secondary_cidr = false
      additional_tags         = {}
    }
    pod_private_2a = {
      cidr_block              = var.pod_subnet_cidrs.pod_private_2a
      availability_zone       = var.azs["2a"]
      name                    = join("-", ["subnet", var.region_code, var.project_name, "pod", "pri-2a"])
      tier                    = "private"
      role                    = "pod"
      route_table             = "pod_private"
      map_public_ip_on_launch = false
      requires_secondary_cidr = true
      additional_tags         = {}
    }
    pod_private_2c = {
      cidr_block              = var.pod_subnet_cidrs.pod_private_2c
      availability_zone       = var.azs["2c"]
      name                    = join("-", ["subnet", var.region_code, var.project_name, "pod", "pri-2c"])
      tier                    = "private"
      role                    = "pod"
      route_table             = "pod_private"
      map_public_ip_on_launch = false
      requires_secondary_cidr = true
      additional_tags         = {}
    }
  }

  primary_subnets = {
    for key, subnet in local.subnet_definitions : key => subnet
    if !subnet.requires_secondary_cidr
  }

  pod_subnets = {
    for key, subnet in local.subnet_definitions : key => subnet
    if subnet.requires_secondary_cidr
  }

  public_subnet_keys = sort([
    for key, subnet in local.primary_subnets : key
    if subnet.route_table == "public"
  ])

  node_private_subnet_keys = sort([
    for key, subnet in local.primary_subnets : key
    if subnet.route_table == "private"
  ])

  db_private_subnet_keys = sort([
    for key, subnet in local.primary_subnets : key
    if subnet.route_table == "db_private"
  ])

  pod_subnet_keys = sort(keys(local.pod_subnets))
}
