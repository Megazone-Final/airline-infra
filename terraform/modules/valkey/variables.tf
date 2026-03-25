variable "region_code" {
  description = "Short region code used in resource naming (e.g., an2)."
  type        = string
}

variable "project_name" {
  description = "Project name used in resource naming (e.g., airline)."
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for ElastiCache placement."
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with ElastiCache."
  type        = list(string)
}

variable "tags" {
  description = "Common tags applied to all Valkey resources."
  type        = map(string)
  default     = {}
}
