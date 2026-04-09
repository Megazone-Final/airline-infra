locals {
  cluster_name = var.alb_cluster_name != "" ? var.alb_cluster_name : join("-", ["eks", var.region_code, var.project_name, "main"])

  names = {
    cluster_role           = join("-", ["iam", var.region_code, var.project_name, "eks", "cluster"])
    cluster_security_group = join("-", ["secgrp", var.region_code, var.project_name, "eks", "cluster"])
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

  managed_node_additional_policy_arns = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    AmazonEBSCSIDriverPolicy     = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  }

  cluster_security_group_base_rules = {
    ingress_nodes_443 = {
      description                = "Allow node traffic to the EKS API"
      protocol                   = "tcp"
      from_port                  = 443
      to_port                    = 443
      type                       = "ingress"
      source_node_security_group = true
    }
    ingress_self_all = {
      description = "Allow cluster self traffic"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
  }

  cluster_security_group_admin_rules = {
    for index, security_group_id in var.eks_api_allowed_security_group_ids :
    "ingress_admin_${index}_443" => {
      description              = "Allow admin traffic to the EKS API from ${security_group_id}"
      protocol                 = "tcp"
      from_port                = 443
      to_port                  = 443
      type                     = "ingress"
      source_security_group_id = security_group_id
    }
  }

  cluster_security_group_additional_rules = merge(
    local.cluster_security_group_base_rules,
    local.cluster_security_group_admin_rules,
  )

  node_subnet_keys = sort(keys(var.node_private_subnet_ids))
  node_subnet_ids = [
    for key in local.node_subnet_keys : var.node_private_subnet_ids[key]
  ]
  managed_node_groups = {
    for group_name, config in var.eks_managed_node_groups :
    group_name => merge(config, {
      name          = join("-", ["mng", var.region_code, var.project_name, "eks", group_name])
      iam_role_name = join("-", ["iam", var.region_code, var.project_name, "eks", "node", group_name])
    })
  }

  pod_subnet_keys = sort(keys(var.pod_private_subnet_ids))
  pod_eni_configs = {
    for key in local.pod_subnet_keys :
    var.azs[replace(key, "pod_private_", "")] => var.pod_private_subnet_ids[key]
  }

  karpenter_managed_node_group_ami_ssm_parameter_name = {
    AL2023_x86_64_STANDARD = "/aws/service/eks/optimized-ami/${var.eks_cluster_version}/amazon-linux-2023/x86_64/standard/recommended/image_id"
    AL2023_ARM_64_STANDARD = "/aws/service/eks/optimized-ami/${var.eks_cluster_version}/amazon-linux-2023/arm64/standard/recommended/image_id"
  }[var.eks_managed_node_group_ami_type]
}
