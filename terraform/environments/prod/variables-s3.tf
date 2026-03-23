variable "s3_logs_enabled" {
  description = "True시 버킷 생성"
  type        = bool
  default     = false
}

variable "s3_infra_enabled" {
  description = "True시 버킷 생성"
  type        = bool
  default     = false
}

variable "s3_web_enabled" {
  description = "True시 버킷 생성"
  type        = bool
  default     = false
}
