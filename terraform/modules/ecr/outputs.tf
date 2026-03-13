output "repository_names" {
  description = "Names of managed ECR repositories."
  value       = keys(aws_ecr_repository.this)
}

output "repository_urls" {
  description = "Map of repository names to repository URLs."
  value       = { for name, repository in aws_ecr_repository.this : name => repository.repository_url }
}
