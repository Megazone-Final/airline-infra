output "eks_cluster_name" {
  description = "Name of the shared EKS cluster."
  value       = module.eks.cluster_name
}

output "eks_cluster_arn" {
  description = "ARN of the shared EKS cluster."
  value       = module.eks.cluster_arn
}

output "eks_cluster_endpoint" {
  description = "Endpoint for the shared EKS Kubernetes API server."
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_admin_principal_arns" {
  description = "IAM principal ARNs granted cluster-admin access before in-cluster resources are applied."
  value       = module.eks.cluster_admin_principal_arns
}

output "eks_api_allowed_security_group_ids" {
  description = "Security group IDs allowed to reach the private EKS API endpoint on port 443."
  value       = module.eks.eks_api_allowed_security_group_ids
}

output "eks_cluster_oidc_provider_arn" {
  description = "OIDC provider ARN used by the shared EKS cluster."
  value       = module.eks.oidc_provider_arn
}

output "eks_cluster_security_group_id" {
  description = "Cluster security group ID for the shared EKS cluster."
  value       = module.eks.cluster_security_group_id
}

output "eks_node_security_group_id" {
  description = "Shared node security group ID for the EKS worker nodes."
  value       = module.eks.node_security_group_id
}

output "eks_managed_node_group_names" {
  description = "Names of the baseline EKS managed node groups."
  value       = module.eks.managed_node_group_names
}

output "eks_managed_node_role_arns" {
  description = "IAM role ARNs used by the baseline EKS managed node groups."
  value       = module.eks.managed_node_role_arns
}

output "eks_pod_eni_config_names" {
  description = "ENIConfig names created for pod subnet mapping."
  value       = module.eks.eni_config_names
}

output "eks_vpc_cni_irsa_role_arn" {
  description = "IAM role ARN attached to the aws-node service account."
  value       = module.eks.vpc_cni_irsa_role_arn
}

output "eks_ebs_csi_irsa_role_arn" {
  description = "IAM role ARN attached to the EBS CSI controller service account."
  value       = module.eks.ebs_csi_irsa_role_arn
}

output "karpenter_controller_role_arn" {
  description = "IAM role ARN used by the Karpenter controller."
  value       = module.eks.karpenter_controller_role_arn
}

output "karpenter_node_role_arn" {
  description = "IAM role ARN used by nodes launched through Karpenter."
  value       = module.eks.karpenter_node_role_arn
}

output "karpenter_interruption_queue_name" {
  description = "SQS queue name used by Karpenter interruption handling."
  value       = module.eks.karpenter_queue_name
}

output "karpenter_node_class_name" {
  description = "Default EC2NodeClass name for Karpenter."
  value       = module.eks.karpenter_node_class_name
}

output "karpenter_node_pool_name" {
  description = "Default NodePool name for Karpenter."
  value       = module.eks.karpenter_node_pool_name
}

output "eks_configure_kubectl" {
  description = "Command used to update the local kubeconfig for the shared EKS cluster."
  value       = "aws eks update-kubeconfig --region ${data.aws_region.current.region} --name ${module.eks.cluster_name}"
}

output "workstation_eks_admin_role_arn" {
  description = "Existing IAM role ARN used by workstation EC2 instances for EKS administration."
  value       = var.workstation_eks_admin_role_arn
}
