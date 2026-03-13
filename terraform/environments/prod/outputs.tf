output "vpc_id" {
  description = "ID of the shared VPC."
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "Private subnet IDs for application workloads."
  value       = module.vpc.private_subnet_ids
}

output "public_subnet_ids" {
  description = "Public subnet IDs for ingress and public endpoints."
  value       = module.vpc.public_subnet_ids
}

output "ecr_repository_urls" {
  description = "Map of ECR repository names to repository URLs."
  value       = module.ecr.repository_urls
}

output "eks_cluster_name" {
  description = "Shared EKS cluster name."
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "Shared EKS cluster endpoint."
  value       = module.eks.cluster_endpoint
}

output "frontend_bucket_name" {
  description = "Frontend static hosting bucket name."
  value       = module.frontend_hosting.bucket_name
}

output "frontend_distribution_domain_name" {
  description = "CloudFront domain name for the frontend."
  value       = module.frontend_hosting.distribution_domain_name
}
