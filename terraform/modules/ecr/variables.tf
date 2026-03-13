variable "enabled" {
  description = "When true, create ECR repositories."
  type        = bool
  default     = true
}

variable "repository_names" {
  description = "List of ECR repository names to create."
  type        = list(string)
}

variable "image_tag_mutability" {
  description = "ECR tag mutability mode."
  type        = string
  default     = "IMMUTABLE"
}

variable "scan_on_push" {
  description = "Enable image scanning on push."
  type        = bool
  default     = true
}

variable "keep_last_images" {
  description = "Number of tagged images to retain."
  type        = number
  default     = 20
}

variable "tags" {
  description = "Tags applied to repositories."
  type        = map(string)
  default     = {}
}
