output "cluster_name" {
  description = "Name of the shared EKS cluster."
  value       = module.cluster.cluster_name
}

output "cluster_arn" {
  description = "ARN of the shared EKS cluster."
  value       = module.cluster.cluster_arn
}

output "cluster_endpoint" {
  description = "Endpoint for the shared EKS Kubernetes API server."
  value       = module.cluster.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded certificate authority data for the shared EKS cluster."
  value       = module.cluster.cluster_certificate_authority_data
}

output "cluster_oidc_issuer_url" {
  description = "OIDC issuer URL used by the shared EKS cluster."
  value       = module.cluster.cluster_oidc_issuer_url
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN used by the shared EKS cluster."
  value       = module.cluster.oidc_provider_arn
}

output "cluster_security_group_id" {
  description = "Cluster security group ID for the shared EKS cluster."
  value       = module.cluster.cluster_security_group_id
}

output "node_security_group_id" {
  description = "Shared node security group ID for the EKS worker nodes."
  value       = module.cluster.node_security_group_id
}

output "managed_node_group_names" {
  description = "Names of the baseline EKS managed node groups."
  value       = [for config in values(local.baseline_managed_node_groups) : config.name]
}

output "managed_node_role_arns" {
  description = "IAM role ARNs used by the baseline EKS managed node groups."
  value = {
    for group_name, group in module.cluster.eks_managed_node_groups :
    group_name => group.iam_role_arn
  }
}

output "node_subnet_ids" {
  description = "Ordered list of node subnet IDs used by the EKS cluster and Karpenter."
  value       = local.node_subnet_ids
}

output "pod_eni_configs" {
  description = "Map of availability zone name to pod subnet ID used by ENIConfig."
  value       = local.pod_eni_configs
}

output "eni_config_names" {
  description = "ENIConfig names created for pod networking."
  value       = sort(keys(local.pod_eni_configs))
}

output "vpc_cni_irsa_role_arn" {
  description = "IAM role ARN attached to the aws-node service account."
  value       = module.vpc_cni_irsa.arn
}

output "ebs_csi_irsa_role_arn" {
  description = "IAM role ARN attached to the EBS CSI controller service account."
  value       = module.ebs_csi_irsa.arn
}

output "karpenter_controller_role_arn" {
  description = "IAM role ARN used by the Karpenter controller."
  value       = module.karpenter.iam_role_arn
}

output "karpenter_node_role_arn" {
  description = "IAM role ARN used by nodes launched through Karpenter."
  value       = module.karpenter.node_iam_role_arn
}

output "karpenter_node_role_name" {
  description = "IAM role name used by nodes launched through Karpenter."
  value       = module.karpenter.node_iam_role_name
}

output "karpenter_queue_name" {
  description = "SQS queue name used by Karpenter interruption handling."
  value       = module.karpenter.queue_name
}

output "karpenter_node_class_name" {
  description = "Default EC2NodeClass name for Karpenter."
  value       = local.names.karpenter_node_class
}

output "karpenter_node_pool_name" {
  description = "Default NodePool name for Karpenter."
  value       = local.names.karpenter_node_pool
}

output "karpenter_node_name" {
  description = "Name tag applied to Karpenter-created nodes."
  value       = local.names.karpenter_node_name
}

output "karpenter_namespace" {
  description = "Namespace where Karpenter is deployed."
  value       = kubernetes_namespace.karpenter.metadata[0].name
}
