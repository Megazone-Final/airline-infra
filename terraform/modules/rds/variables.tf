variable "region_code" {
  description = "Short region code used in resource naming (e.g., an2)."
  type        = string
}

variable "project_name" {
  description = "Project name used in resource naming (e.g., airline)."
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the RDS DB subnet group."
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to associate with the RDS cluster and instances."
  type        = list(string)
}

variable "proxy_subnet_ids" {
  description = "List of subnet IDs for the RDS Proxy."
  type        = list(string)
}

variable "proxy_security_group_ids" {
  description = "List of security group IDs to associate with the RDS Proxy."
  type        = list(string)
}



variable "tags" {
  description = "Common tags applied to all RDS resources."
  type        = map(string)
  default     = {}
}
