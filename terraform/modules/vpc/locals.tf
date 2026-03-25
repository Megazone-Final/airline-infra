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

  subnet_definitions = {
    for key, subnet in var.subnets : key => merge(subnet, {
      additional_tags         = lookup(var.subnet_tags, key, {})
      requires_secondary_cidr = subnet.address_family == "secondary"
    })
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
