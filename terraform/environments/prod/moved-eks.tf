moved {
  from = module.eks.aws_cloudwatch_log_group.this[0]
  to   = module.eks.module.cluster.aws_cloudwatch_log_group.this[0]
}

moved {
  from = module.eks.aws_ec2_tag.cluster_primary_security_group["Environment"]
  to   = module.eks.module.cluster.aws_ec2_tag.cluster_primary_security_group["Environment"]
}

moved {
  from = module.eks.aws_ec2_tag.cluster_primary_security_group["ManagedBy"]
  to   = module.eks.module.cluster.aws_ec2_tag.cluster_primary_security_group["ManagedBy"]
}

moved {
  from = module.eks.aws_ec2_tag.cluster_primary_security_group["Project"]
  to   = module.eks.module.cluster.aws_ec2_tag.cluster_primary_security_group["Project"]
}

moved {
  from = module.eks.aws_eks_access_entry.this["cluster_creator"]
  to   = module.eks.module.cluster.aws_eks_access_entry.this["cluster_creator"]
}

moved {
  from = module.eks.aws_eks_access_policy_association.this["cluster_creator_admin"]
  to   = module.eks.module.cluster.aws_eks_access_policy_association.this["cluster_creator_admin"]
}

moved {
  from = module.eks.aws_eks_addon.before_compute["eks-pod-identity-agent"]
  to   = module.eks.module.cluster.aws_eks_addon.before_compute["eks-pod-identity-agent"]
}

moved {
  from = module.eks.aws_eks_addon.before_compute["vpc-cni"]
  to   = module.eks.module.cluster.aws_eks_addon.before_compute["vpc-cni"]
}

moved {
  from = module.eks.aws_eks_addon.this["aws-ebs-csi-driver"]
  to   = module.eks.module.cluster.aws_eks_addon.this["aws-ebs-csi-driver"]
}

moved {
  from = module.eks.aws_eks_addon.this["coredns"]
  to   = module.eks.module.cluster.aws_eks_addon.this["coredns"]
}

moved {
  from = module.eks.aws_eks_addon.this["kube-proxy"]
  to   = module.eks.module.cluster.aws_eks_addon.this["kube-proxy"]
}

moved {
  from = module.eks.aws_eks_cluster.this[0]
  to   = module.eks.module.cluster.aws_eks_cluster.this[0]
}

moved {
  from = module.eks.aws_iam_openid_connect_provider.oidc_provider[0]
  to   = module.eks.module.cluster.aws_iam_openid_connect_provider.oidc_provider[0]
}

moved {
  from = module.eks.aws_iam_role.this[0]
  to   = module.eks.module.cluster.aws_iam_role.this[0]
}

moved {
  from = module.eks.aws_iam_role_policy_attachment.this["AmazonEKSClusterPolicy"]
  to   = module.eks.module.cluster.aws_iam_role_policy_attachment.this["AmazonEKSClusterPolicy"]
}

moved {
  from = module.eks.aws_iam_role_policy_attachment.this["AmazonEKSVPCResourceController"]
  to   = module.eks.module.cluster.aws_iam_role_policy_attachment.this["AmazonEKSVPCResourceController"]
}

moved {
  from = module.eks.aws_security_group.cluster[0]
  to   = module.eks.module.cluster.aws_security_group.cluster[0]
}

moved {
  from = module.eks.aws_security_group.node[0]
  to   = module.eks.module.cluster.aws_security_group.node[0]
}

moved {
  from = module.eks.aws_security_group_rule.cluster["ingress_nodes_443"]
  to   = module.eks.module.cluster.aws_security_group_rule.cluster["ingress_nodes_443"]
}

moved {
  from = module.eks.aws_security_group_rule.cluster["ingress_self_all"]
  to   = module.eks.module.cluster.aws_security_group_rule.cluster["ingress_self_all"]
}

moved {
  from = module.eks.aws_security_group_rule.node["egress_all"]
  to   = module.eks.module.cluster.aws_security_group_rule.node["egress_all"]
}

moved {
  from = module.eks.aws_security_group_rule.node["ingress_cluster_10251_webhook"]
  to   = module.eks.module.cluster.aws_security_group_rule.node["ingress_cluster_10251_webhook"]
}

moved {
  from = module.eks.aws_security_group_rule.node["ingress_cluster_443"]
  to   = module.eks.module.cluster.aws_security_group_rule.node["ingress_cluster_443"]
}

moved {
  from = module.eks.aws_security_group_rule.node["ingress_cluster_4443_webhook"]
  to   = module.eks.module.cluster.aws_security_group_rule.node["ingress_cluster_4443_webhook"]
}

moved {
  from = module.eks.aws_security_group_rule.node["ingress_cluster_6443_webhook"]
  to   = module.eks.module.cluster.aws_security_group_rule.node["ingress_cluster_6443_webhook"]
}

moved {
  from = module.eks.aws_security_group_rule.node["ingress_cluster_8443_webhook"]
  to   = module.eks.module.cluster.aws_security_group_rule.node["ingress_cluster_8443_webhook"]
}

moved {
  from = module.eks.aws_security_group_rule.node["ingress_cluster_9443_webhook"]
  to   = module.eks.module.cluster.aws_security_group_rule.node["ingress_cluster_9443_webhook"]
}

moved {
  from = module.eks.aws_security_group_rule.node["ingress_cluster_kubelet"]
  to   = module.eks.module.cluster.aws_security_group_rule.node["ingress_cluster_kubelet"]
}

moved {
  from = module.eks.aws_security_group_rule.node["ingress_nodes_ephemeral"]
  to   = module.eks.module.cluster.aws_security_group_rule.node["ingress_nodes_ephemeral"]
}

moved {
  from = module.eks.aws_security_group_rule.node["ingress_self_coredns_tcp"]
  to   = module.eks.module.cluster.aws_security_group_rule.node["ingress_self_coredns_tcp"]
}

moved {
  from = module.eks.aws_security_group_rule.node["ingress_self_coredns_udp"]
  to   = module.eks.module.cluster.aws_security_group_rule.node["ingress_self_coredns_udp"]
}

moved {
  from = module.eks.time_sleep.this[0]
  to   = module.eks.module.cluster.time_sleep.this[0]
}

moved {
  from = module.eks_ebs_csi_irsa
  to   = module.eks.module.ebs_csi_irsa
}

moved {
  from = module.eks_vpc_cni_irsa
  to   = module.eks.module.vpc_cni_irsa
}

moved {
  from = module.eks.module.eks_managed_node_group["mng-an2-airline-eks-system"]
  to   = module.eks.module.cluster.module.eks_managed_node_group["mng-an2-airline-eks-system"]
}
