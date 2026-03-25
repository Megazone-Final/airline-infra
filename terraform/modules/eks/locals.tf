locals {
  cluster_name = var.alb_cluster_name != "" ? var.alb_cluster_name : join("-", ["eks", var.region_code, var.project_name, "main"])

  names = {
    cluster_role           = join("-", ["iam", var.region_code, var.project_name, "eks", "cluster"])
    cluster_security_group = join("-", ["secgrp", var.region_code, var.project_name, "eks", "cluster"])
    managed_node_group     = join("-", ["mng", var.region_code, var.project_name, "eks", "system"])
    managed_node_role      = join("-", ["iam", var.region_code, var.project_name, "eks", "node"])
    node_security_group    = join("-", ["secgrp", var.region_code, var.project_name, "eks", "node"])
    karpenter_controller   = join("-", ["iam", var.region_code, var.project_name, "karpenter", "controller"])
    karpenter_node         = join("-", ["iam", var.region_code, var.project_name, "karpenter", "node"])
    karpenter_queue        = join("-", ["sqs", var.region_code, var.project_name, "karpenter", "events"])
    karpenter_rule_prefix  = "${join("-", ["evt", var.region_code, substr(var.project_name, 0, 3), "krp"])}-"
    karpenter_node_class   = join("-", ["nodeclass", var.region_code, var.project_name, "karpenter", "main"])
    karpenter_node_pool    = join("-", ["nodepool", var.region_code, var.project_name, "karpenter", "main"])
    karpenter_node_name    = join("-", ["ec2", var.region_code, var.project_name, "karpenter", "node"])
    vpc_cni_irsa           = join("-", ["iam", var.region_code, var.project_name, "vpc-cni", "irsa"])
    ebs_csi_irsa           = join("-", ["iam", var.region_code, var.project_name, "ebs-csi", "irsa"])
  }

  node_subnet_keys = sort(keys(var.node_private_subnet_ids))
  node_subnet_ids = [
    for key in local.node_subnet_keys : var.node_private_subnet_ids[key]
  ]
  baseline_managed_node_groups = {
    for subnet_key in local.node_subnet_keys :
    replace(subnet_key, "node_private_", "") => {
      name          = "${local.names.managed_node_group}-${replace(subnet_key, "node_private_", "")}"
      subnet_id     = var.node_private_subnet_ids[subnet_key]
      iam_role_name = "${local.names.managed_node_role}-${replace(subnet_key, "node_private_", "")}"
    }
  }

  pod_subnet_keys = sort(keys(var.pod_private_subnet_ids))
  pod_eni_configs = {
    for key in local.pod_subnet_keys :
    var.azs[replace(key, "pod_private_", "")] => var.pod_private_subnet_ids[key]
  }
}
