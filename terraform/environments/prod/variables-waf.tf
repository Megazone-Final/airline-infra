variable "waf_cloudfront_enabled" {
  description = "When true, create the CloudFront WAFv2 Web ACL."
  type        = bool
  default     = false
}
