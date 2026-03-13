variable "enabled" {
  description = "When true, create the frontend static hosting stack."
  type        = bool
  default     = true
}

variable "name" {
  description = "Base name used for resource naming."
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket name for frontend assets."
  type        = string
}

variable "aliases" {
  description = "Optional CloudFront aliases."
  type        = list(string)
  default     = []
}

variable "acm_certificate_arn" {
  description = "Optional ACM certificate ARN in us-east-1 for custom domains."
  type        = string
  default     = null
}

variable "default_root_object" {
  description = "Default object served by CloudFront."
  type        = string
  default     = "index.html"
}

variable "price_class" {
  description = "CloudFront price class."
  type        = string
  default     = "PriceClass_200"
}

variable "enable_spa_routing" {
  description = "Map SPA routes to index.html."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to supported resources."
  type        = map(string)
  default     = {}
}
