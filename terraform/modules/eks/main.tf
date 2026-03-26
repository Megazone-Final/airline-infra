data "aws_region" "current" {}

module "vpc_cni_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version = "~> 6.4"

  name            = local.names.vpc_cni_irsa
  use_name_prefix = false

  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = module.cluster.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }

  tags = merge(var.tags, {
    Name = local.names.vpc_cni_irsa
  })
}

module "ebs_csi_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version = "~> 6.4"

  name            = local.names.ebs_csi_irsa
  use_name_prefix = false

  attach_ebs_csi_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.cluster.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }

  tags = merge(var.tags, {
    Name = local.names.ebs_csi_irsa
  })
}

module "cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.15"

  name               = local.cluster_name
  kubernetes_version = var.eks_cluster_version

  authentication_mode                      = "API_AND_CONFIG_MAP"
  enable_cluster_creator_admin_permissions = false
  enable_irsa                              = true
  endpoint_public_access                   = var.eks_endpoint_public_access
  endpoint_private_access                  = var.eks_endpoint_private_access
  endpoint_public_access_cidrs             = var.eks_endpoint_public_access_cidrs
  enabled_log_types                        = var.eks_enabled_log_types
  cloudwatch_log_group_retention_in_days   = var.eks_cloudwatch_log_retention_in_days
  encryption_config                        = null
  service_ipv4_cidr                        = var.eks_service_ipv4_cidr
  vpc_id                                   = var.vpc_id
  subnet_ids                               = local.node_subnet_ids
  create_security_group                    = true
  security_group_name                      = local.names.cluster_security_group
  security_group_use_name_prefix           = false
  security_group_description               = "EKS cluster security group for ${local.cluster_name}"
  create_node_security_group               = true
  node_security_group_name                 = local.names.node_security_group
  node_security_group_use_name_prefix      = false
  node_security_group_description          = "EKS node security group for ${local.cluster_name}"
  iam_role_name                            = local.names.cluster_role
  iam_role_use_name_prefix                 = false
  iam_role_description                     = "IAM role for the ${local.cluster_name} EKS control plane"

  security_group_additional_rules = {
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

  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION           = "true"
          WARM_PREFIX_TARGET                 = tostring(var.eks_vpc_cni_warm_prefix_target)
          AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG = "true"
          ENI_CONFIG_LABEL_DEF               = "topology.kubernetes.io/zone"
        }
      })
      service_account_role_arn = module.vpc_cni_irsa.arn
    }
    aws-ebs-csi-driver = {
      service_account_role_arn = module.ebs_csi_irsa.arn
    }
  }

  eks_managed_node_groups = {
    for az_suffix, config in local.baseline_managed_node_groups :
    config.name => {
      ami_type       = var.eks_managed_node_group_ami_type
      instance_types = var.eks_managed_node_group_instance_types
      capacity_type  = var.eks_managed_node_group_capacity_type
      disk_size      = var.eks_managed_node_group_disk_size
      subnet_ids     = [config.subnet_id]

      desired_size = var.eks_managed_node_group_desired_size
      min_size     = var.eks_managed_node_group_min_size
      max_size     = var.eks_managed_node_group_max_size

      iam_role_name            = config.iam_role_name
      iam_role_use_name_prefix = false
      iam_role_description     = "IAM role for the ${config.name} EKS managed node group"

      iam_role_additional_policies = {
        AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
        AmazonEBSCSIDriverPolicy     = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }

      labels = {
        role                      = "managed-nodegroup"
        "karpenter.sh/controller" = "true"
      }

      tags = merge(var.tags, {
        Name = config.name
      })
    }
  }

  security_group_tags = merge(var.tags, {
    Name = local.names.cluster_security_group
  })

  node_security_group_tags = merge(var.tags, {
    Name = local.names.node_security_group
  })

  tags = merge(var.tags, {
    Name = local.cluster_name
  })
}

resource "aws_eks_access_entry" "cluster_admin" {
  for_each = var.cluster_admin_principal_arns

  cluster_name  = module.cluster.cluster_name
  principal_arn = each.value
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "cluster_admin" {
  for_each = var.cluster_admin_principal_arns

  cluster_name  = module.cluster.cluster_name
  principal_arn = each.value
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.cluster_admin]
}

resource "time_sleep" "cluster_admin_access_ready" {
  create_duration = var.cluster_admin_access_ready_wait_duration

  triggers = {
    cluster_name             = module.cluster.cluster_name
    cluster_endpoint         = module.cluster.cluster_endpoint
    cluster_admin_principals = jsonencode(var.cluster_admin_principal_arns)
  }

  depends_on = [aws_eks_access_policy_association.cluster_admin]
}

module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "~> 21.15"

  cluster_name    = module.cluster.cluster_name
  region          = data.aws_region.current.region
  namespace       = var.eks_karpenter_namespace
  service_account = var.eks_karpenter_service_account_name

  iam_role_name            = local.names.karpenter_controller
  iam_role_use_name_prefix = false

  node_iam_role_name            = local.names.karpenter_node
  node_iam_role_use_name_prefix = false

  queue_name       = local.names.karpenter_queue
  rule_name_prefix = local.names.karpenter_rule_prefix

  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    AmazonEBSCSIDriverPolicy     = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  }

  tags = var.tags

  depends_on = [
    module.cluster,
    time_sleep.cluster_admin_access_ready,
  ]
}
