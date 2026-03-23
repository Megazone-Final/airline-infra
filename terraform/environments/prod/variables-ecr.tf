variable "ecr_enabled" {
  description = "When true, create shared ECR repositories."
  type        = bool
  default     = true
}

variable "ecr_repository_names" {
  description = "List of shared ECR repository names."
  type        = list(string)
  default = [
    "airline-backend/auth",
    "airline-backend/flight",
    "airline-backend/payment",
  ]
}

variable "ecr_image_tag_mutability" {
  description = "Tag mutability mode applied to shared ECR repositories."
  type        = string
  default     = "IMMUTABLE"
}

variable "ecr_scan_on_push" {
  description = "Enable registry-level scan on push for the shared ECR repositories."
  type        = bool
  default     = true
}

variable "ecr_keep_last_images" {
  description = "Number of tagged images to keep per shared ECR repository."
  type        = number
  default     = 5
}
