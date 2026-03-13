output "ecr_repository_names" {
  description = "Names of shared ECR repositories."
  value       = module.ecr.repository_names
}

output "ecr_repository_urls" {
  description = "Repository URLs of shared ECR repositories."
  value       = module.ecr.repository_urls
}
