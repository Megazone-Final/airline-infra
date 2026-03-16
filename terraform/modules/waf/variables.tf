variable "enabled" {
  description = "When true, create the CloudFront WAFv2 Web ACL."
  type        = bool
  default     = true
}

variable "region_code" {
  description = "Short region code used in the resource naming convention."
  type        = string
}

variable "project_name" {
  description = "Project name used in the resource naming convention."
  type        = string
}

variable "tags" {
  description = "Tags applied to the WAF resources."
  type        = map(string)
  default     = {}
}
