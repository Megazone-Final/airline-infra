locals {
  primary_subnet_cidrs = {
    edge_public_2a  = var.subnet_cidrs.edge_public_2a
    edge_public_2c  = var.subnet_cidrs.edge_public_2c
    node_private_2a = var.subnet_cidrs.node_private_2a
    node_private_2c = var.subnet_cidrs.node_private_2c
    db_private_2a   = var.subnet_cidrs.db_private_2a
    db_private_2c   = var.subnet_cidrs.db_private_2c
  }

  pod_subnet_cidrs = {
    pod_private_2a = var.pod_subnet_cidrs.pod_private_2a
    pod_private_2c = var.pod_subnet_cidrs.pod_private_2c
  }

  primary_parent_prefix = tonumber(split("/", var.cidr_block)[1])
  pod_parent_prefix     = tonumber(split("/", var.pod_secondary_cidr)[1])

  primary_parent_start = sum([
    for idx, octet in split(".", cidrhost(var.cidr_block, 0)) :
    tonumber(octet) * pow(256, 3 - idx)
  ])
  primary_parent_end = local.primary_parent_start + pow(2, 32 - local.primary_parent_prefix) - 1

  pod_parent_start = sum([
    for idx, octet in split(".", cidrhost(var.pod_secondary_cidr, 0)) :
    tonumber(octet) * pow(256, 3 - idx)
  ])
  pod_parent_end = local.pod_parent_start + pow(2, 32 - local.pod_parent_prefix) - 1

  primary_subnet_ranges = {
    for key, cidr in local.primary_subnet_cidrs : key => {
      prefix = tonumber(split("/", cidr)[1])
      start = sum([
        for idx, octet in split(".", cidrhost(cidr, 0)) :
        tonumber(octet) * pow(256, 3 - idx)
      ])
      size = pow(2, 32 - tonumber(split("/", cidr)[1]))
    }
  }

  pod_subnet_ranges = {
    for key, cidr in local.pod_subnet_cidrs : key => {
      prefix = tonumber(split("/", cidr)[1])
      start = sum([
        for idx, octet in split(".", cidrhost(cidr, 0)) :
        tonumber(octet) * pow(256, 3 - idx)
      ])
      size = pow(2, 32 - tonumber(split("/", cidr)[1]))
    }
  }
}

check "required_az_keys" {
  assert {
    condition     = contains(keys(var.azs), "2a") && contains(keys(var.azs), "2c")
    error_message = "The azs map must define both 2a and 2c keys."
  }
}

check "valid_primary_and_secondary_cidrs" {
  assert {
    condition = alltrue([
      can(cidrnetmask(var.cidr_block)),
      can(cidrnetmask(var.pod_secondary_cidr)),
      can(cidrnetmask(var.subnet_cidrs.edge_public_2a)),
      can(cidrnetmask(var.subnet_cidrs.edge_public_2c)),
      can(cidrnetmask(var.subnet_cidrs.node_private_2a)),
      can(cidrnetmask(var.subnet_cidrs.node_private_2c)),
      can(cidrnetmask(var.subnet_cidrs.db_private_2a)),
      can(cidrnetmask(var.subnet_cidrs.db_private_2c)),
      can(cidrnetmask(var.pod_subnet_cidrs.pod_private_2a)),
      can(cidrnetmask(var.pod_subnet_cidrs.pod_private_2c)),
    ])
    error_message = "All VPC and subnet CIDR values must be valid IPv4 CIDR blocks."
  }
}

check "non_overlapping_subnet_cidrs" {
  assert {
    condition = length(distinct([
      var.subnet_cidrs.edge_public_2a,
      var.subnet_cidrs.edge_public_2c,
      var.subnet_cidrs.node_private_2a,
      var.subnet_cidrs.node_private_2c,
      var.subnet_cidrs.db_private_2a,
      var.subnet_cidrs.db_private_2c,
      var.pod_subnet_cidrs.pod_private_2a,
      var.pod_subnet_cidrs.pod_private_2c,
    ])) == 8
    error_message = "Each subnet CIDR block must be unique."
  }
}

check "subnets_use_more_specific_prefixes" {
  assert {
    condition = alltrue([
      for subnet in values(local.primary_subnet_ranges) : subnet.prefix > local.primary_parent_prefix
      ]) && alltrue([
      for subnet in values(local.pod_subnet_ranges) : subnet.prefix > local.pod_parent_prefix
    ])
    error_message = "Each subnet CIDR must use a more specific prefix length than its parent VPC CIDR."
  }
}

check "subnets_fit_within_parent_cidrs" {
  assert {
    condition = alltrue([
      for subnet in values(local.primary_subnet_ranges) :
      subnet.start >= local.primary_parent_start && (subnet.start + subnet.size - 1) <= local.primary_parent_end
      ]) && alltrue([
      for subnet in values(local.pod_subnet_ranges) :
      subnet.start >= local.pod_parent_start && (subnet.start + subnet.size - 1) <= local.pod_parent_end
    ])
    error_message = "Every subnet CIDR must be fully contained within its parent VPC CIDR block."
  }
}
