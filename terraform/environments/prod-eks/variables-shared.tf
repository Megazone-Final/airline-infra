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
