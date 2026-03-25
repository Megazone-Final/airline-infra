module "eks" {
  source = "../../modules/eks"

  region_code             = var.region_code
  project_name            = var.project_name
  alb_cluster_name        = data.terraform_remote_state.network.outputs.eks_cluster_name
  azs                     = var.azs
  vpc_id                  = data.terraform_remote_state.network.outputs.vpc_id
  node_private_subnet_ids = data.terraform_remote_state.network.outputs.node_private_subnet_ids
  pod_private_subnet_ids  = data.terraform_remote_state.network.outputs.pod_private_subnet_ids
  cluster_admin_principal_arns = {
    workstation = aws_iam_role.workstation_eks_admin.arn
  }

  eks_cluster_version                   = var.eks_cluster_version
  eks_service_ipv4_cidr                 = var.eks_service_ipv4_cidr
  eks_endpoint_public_access            = var.eks_endpoint_public_access
  eks_endpoint_private_access           = var.eks_endpoint_private_access
  eks_endpoint_public_access_cidrs      = var.eks_endpoint_public_access_cidrs
  eks_enabled_log_types                 = var.eks_enabled_log_types
  eks_cloudwatch_log_retention_in_days  = var.eks_cloudwatch_log_retention_in_days
  eks_managed_node_group_ami_type       = var.eks_managed_node_group_ami_type
  eks_managed_node_group_instance_types = var.eks_managed_node_group_instance_types
  eks_managed_node_group_capacity_type  = var.eks_managed_node_group_capacity_type
  eks_managed_node_group_disk_size      = var.eks_managed_node_group_disk_size
  eks_managed_node_group_desired_size   = var.eks_managed_node_group_desired_size
  eks_managed_node_group_min_size       = var.eks_managed_node_group_min_size
  eks_managed_node_group_max_size       = var.eks_managed_node_group_max_size
  eks_karpenter_chart_version           = var.eks_karpenter_chart_version
  eks_karpenter_namespace               = var.eks_karpenter_namespace
  eks_karpenter_service_account_name    = var.eks_karpenter_service_account_name
  eks_karpenter_ami_family              = var.eks_karpenter_ami_family
  eks_karpenter_ami_alias               = var.eks_karpenter_ami_alias
  eks_karpenter_ami_id                  = var.eks_karpenter_ami_id
  eks_karpenter_instance_categories     = var.eks_karpenter_instance_categories
  eks_karpenter_architectures           = var.eks_karpenter_architectures
  eks_karpenter_capacity_types          = var.eks_karpenter_capacity_types
  eks_karpenter_consolidation_policy    = var.eks_karpenter_consolidation_policy
  eks_karpenter_consolidate_after       = var.eks_karpenter_consolidate_after
  eks_vpc_cni_warm_prefix_target        = var.eks_vpc_cni_warm_prefix_target
  tags                                  = local.common_tags
}
