output "waf_cloudfront_name" {
  description = "Name of the CloudFront WAFv2 Web ACL."
  value       = module.waf_cloudfront.cloudfront_name
}

output "waf_cloudfront_arn" {
  description = "ARN of the CloudFront WAFv2 Web ACL."
  value       = module.waf_cloudfront.cloudfront_arn
}
