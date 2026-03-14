output "cloudfront_name" {
  description = "Name of the CloudFront WAFv2 Web ACL."
  value       = try(aws_wafv2_web_acl.cloudfront[0].name, null)
}

output "cloudfront_arn" {
  description = "ARN of the CloudFront WAFv2 Web ACL."
  value       = try(aws_wafv2_web_acl.cloudfront[0].arn, null)
}
