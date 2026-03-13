output "cluster_name" {
  description = "EKS cluster name."
  value       = try(aws_eks_cluster.this[0].name, null)
}

output "cluster_arn" {
  description = "EKS cluster ARN."
  value       = try(aws_eks_cluster.this[0].arn, null)
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint."
  value       = try(aws_eks_cluster.this[0].endpoint, null)
}

output "cluster_security_group_id" {
  description = "Cluster security group ID."
  value       = try(aws_security_group.cluster[0].id, null)
}

output "oidc_issuer" {
  description = "OIDC issuer URL for the cluster."
  value       = try(aws_eks_cluster.this[0].identity[0].oidc[0].issuer, null)
}

output "node_role_arn" {
  description = "IAM role ARN used by managed worker nodes."
  value       = try(aws_iam_role.node[0].arn, null)
}
