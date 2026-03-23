variable "waf_cloudfront_enabled" {
  description = "When true, create the CloudFront WAFv2 Web ACL."
  type        = bool
  default     = false
}

variable "waf_admin_protection_enabled" {
  description = "When true, only allow configured IP ranges to access the admin host on CloudFront."
  type        = bool
  default     = true
}

variable "waf_admin_host" {
  description = "Admin host name protected by stricter WAF rules."
  type        = string
  default     = "admin.izones.cloud"
}

variable "waf_admin_allowed_ip_cidrs" {
  description = "CIDR ranges allowed to access the admin host."
  type        = list(string)
  default = [
    "210.181.0.0/16",
  ]
}
