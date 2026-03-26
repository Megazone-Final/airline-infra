variable "project_name" {
  description = "Project name used for resource naming."
  type        = string
  default     = "airline"
}

variable "aws_region" {
  description = "AWS region used by this environment."
  type        = string
  default     = "ap-northeast-2"
}

variable "region_code" {
  description = "Short region code used in the resource naming convention."
  type        = string
  default     = "an2"
}

variable "environment" {
  description = "Logical environment name."
  type        = string
  default     = "prod"
}

variable "workstation_eks_admin_role_arn" {
  description = "Existing IAM role ARN used by workstation EC2 instances for EKS administration."
  type        = string
  default     = "arn:aws:iam::036333380579:role/iam-global-airline-ssm"

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.workstation_eks_admin_role_arn))
    error_message = "workstation_eks_admin_role_arn must be a valid IAM role ARN."
  }
}

variable "workstation_security_group_ids" {
  description = "Security group IDs attached to workstation EC2 instances that need private EKS API access."
  type        = list(string)
  default     = ["sg-055d55475a303704c"]

  validation {
    condition     = alltrue([for security_group_id in var.workstation_security_group_ids : can(regex("^sg-[0-9a-f]+$", security_group_id))])
    error_message = "workstation_security_group_ids must contain valid EC2 security group IDs."
  }
}

variable "tags" {
  description = "Additional tags applied to supported resources."
  type        = map(string)
  default     = {}
}

variable "azs" {
  description = "Availability zones keyed by short suffix."
  type        = map(string)
  default = {
    "2a" = "ap-northeast-2a"
    "2c" = "ap-northeast-2c"
  }
}
