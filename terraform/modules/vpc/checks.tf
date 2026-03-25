locals {
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

  subnet_ranges = {
    for key, subnet in local.subnet_definitions : key => {
      cidr_block     = subnet.cidr_block
      address_family = subnet.address_family
      prefix         = tonumber(split("/", subnet.cidr_block)[1])
      start = sum([
        for idx, octet in split(".", cidrhost(subnet.cidr_block, 0)) :
        tonumber(octet) * pow(256, 3 - idx)
      ])
      end = sum([
        for idx, octet in split(".", cidrhost(subnet.cidr_block, 0)) :
        tonumber(octet) * pow(256, 3 - idx)
      ]) + pow(2, 32 - tonumber(split("/", subnet.cidr_block)[1])) - 1
    }
  }

  subnet_range_keys = sort(keys(local.subnet_ranges))

  subnet_overlap_pairs = flatten([
    for left_index, left_key in local.subnet_range_keys : [
      for right_index, right_key in local.subnet_range_keys : {
        left_key  = left_key
        right_key = right_key
        overlaps = (
          local.subnet_ranges[left_key].start <= local.subnet_ranges[right_key].end
          && local.subnet_ranges[right_key].start <= local.subnet_ranges[left_key].end
        )
      } if left_index < right_index
    ]
  ])
}

check "valid_parent_cidrs" {
  assert {
    condition = alltrue([
      can(cidrnetmask(var.cidr_block)),
      can(cidrnetmask(var.pod_secondary_cidr)),
    ])
    error_message = "The VPC primary and secondary CIDRs must be valid IPv4 CIDR blocks."
  }
}

check "valid_subnet_configuration" {
  assert {
    condition = alltrue([
      for subnet in values(local.subnet_definitions) :
      can(cidrnetmask(subnet.cidr_block))
      && (
        subnet.address_family == "primary"
        ? (
          (
            subnet.route_table == "public"
            && subnet.tier == "public"
            && subnet.map_public_ip_on_launch
          )
          || (
            contains(["private", "db_private"], subnet.route_table)
            && subnet.tier == "private"
            && !subnet.map_public_ip_on_launch
          )
        )
        : (
          subnet.address_family == "secondary"
          && subnet.route_table == "pod_private"
          && subnet.tier == "private"
          && !subnet.map_public_ip_on_launch
        )
      )
    ])
    error_message = "Subnet topology is invalid. Public primary subnets must use the public route table and public IP mapping. Private primary subnets must use private/db_private route tables without public IP mapping. Secondary subnets must use the pod_private route table."
  }
}

check "non_overlapping_subnet_cidrs" {
  assert {
    condition     = alltrue([for pair in local.subnet_overlap_pairs : !pair.overlaps])
    error_message = "Subnet CIDR blocks must not overlap, even when the strings differ."
  }
}

check "primary_and_secondary_cidrs_do_not_overlap" {
  assert {
    condition     = local.primary_parent_end < local.pod_parent_start || local.pod_parent_end < local.primary_parent_start
    error_message = "The primary and secondary VPC CIDR blocks must not overlap."
  }
}

check "subnets_use_more_specific_prefixes" {
  assert {
    condition = alltrue([
      for subnet in values(local.subnet_ranges) :
      subnet.address_family == "primary" ? subnet.prefix > local.primary_parent_prefix : subnet.prefix > local.pod_parent_prefix
    ])
    error_message = "Each subnet CIDR must use a more specific prefix length than its parent VPC CIDR."
  }
}

check "subnets_fit_within_parent_cidrs" {
  assert {
    condition = alltrue([
      for subnet in values(local.subnet_ranges) :
      subnet.address_family == "primary"
      ? subnet.start >= local.primary_parent_start && subnet.end <= local.primary_parent_end
      : subnet.start >= local.pod_parent_start && subnet.end <= local.pod_parent_end
    ])
    error_message = "Every subnet CIDR must be fully contained within its parent VPC CIDR block."
  }
}
