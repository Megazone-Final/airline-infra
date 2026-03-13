output "bucket_name" {
  description = "Frontend asset bucket name."
  value       = try(aws_s3_bucket.this[0].bucket, null)
}

output "bucket_arn" {
  description = "Frontend asset bucket ARN."
  value       = try(aws_s3_bucket.this[0].arn, null)
}

output "distribution_id" {
  description = "CloudFront distribution ID."
  value       = try(aws_cloudfront_distribution.this[0].id, null)
}

output "distribution_domain_name" {
  description = "CloudFront distribution domain name."
  value       = try(aws_cloudfront_distribution.this[0].domain_name, null)
}
