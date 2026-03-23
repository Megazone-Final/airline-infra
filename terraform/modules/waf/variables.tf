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

variable "admin_protection_enabled" {
  description = "When true, only allow configured IP ranges to access the admin host."
  type        = bool
  default     = true
}

variable "admin_host" {
  description = "Optional admin host name protected by stricter WAF rules."
  type        = string
  default     = ""
}

variable "admin_allowed_ip_cidrs" {
  description = "CIDR ranges allowed to access the admin host."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags applied to the WAF resources."
  type        = map(string)
  default     = {}
}
