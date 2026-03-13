variable "project_name" {
  description = "Project name used for resource naming."
  type        = string
  default     = "airline"
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

variable "enable_vpc" {
  description = "When true, create the shared VPC."
  type        = bool
  default     = false
}

variable "vpc_cidr" {
  description = "CIDR block for the shared VPC."
  type        = string
  default     = "10.20.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones used by the shared VPC."
  type        = list(string)
  default     = ["ap-northeast-2a", "ap-northeast-2c"]
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks, one per availability zone."
  type        = list(string)
  default     = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks, one per availability zone."
  type        = list(string)
  default     = ["10.20.11.0/24", "10.20.12.0/24"]
}

variable "create_nat_gateway" {
  description = "Create a single NAT gateway for private subnet egress."
  type        = bool
  default     = false
}

variable "enable_ecr" {
  description = "When true, create ECR repositories for backend services."
  type        = bool
  default     = false
}

variable "ecr_repository_names" {
  description = "Names of ECR repositories to create."
  type        = list(string)
  default = [
    "airline-backend/auth",
    "airline-backend/flights",
    "airline-backend/payments",
  ]
}

variable "ecr_image_tag_mutability" {
  description = "ECR image tag mutability mode."
  type        = string
  default     = "MUTABLE"
}

variable "ecr_scan_on_push" {
  description = "Enable image scanning on push for ECR repositories."
  type        = bool
  default     = true
}

variable "ecr_keep_last_images" {
  description = "Number of tagged images to retain in each ECR repository."
  type        = number
  default     = 20
}

variable "enable_eks" {
  description = "When true, create the shared EKS cluster and node group."
  type        = bool
  default     = false
}

variable "eks_cluster_version" {
  description = "Kubernetes version for the EKS cluster."
  type        = string
  default     = "1.30"
}

variable "eks_service_ipv4_cidr" {
  description = "Service CIDR for the EKS cluster."
  type        = string
  default     = "172.20.0.0/16"
}

variable "eks_endpoint_public_access" {
  description = "Expose the EKS API endpoint publicly."
  type        = bool
  default     = true
}

variable "eks_endpoint_private_access" {
  description = "Expose the EKS API endpoint privately inside the VPC."
  type        = bool
  default     = true
}

variable "eks_endpoint_public_access_cidrs" {
  description = "Allowed CIDRs for public access to the EKS API endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "eks_cluster_log_types" {
  description = "Enabled EKS control plane log types."
  type        = list(string)
  default     = ["api", "audit", "authenticator"]
}

variable "eks_log_retention_in_days" {
  description = "Retention days for EKS control plane logs."
  type        = number
  default     = 7
}

variable "eks_node_group_name" {
  description = "Name of the managed node group."
  type        = string
  default     = "default"
}

variable "eks_node_instance_types" {
  description = "Instance types for the managed node group."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "eks_node_capacity_type" {
  description = "Capacity type for the managed node group."
  type        = string
  default     = "ON_DEMAND"
}

variable "eks_node_disk_size" {
  description = "Disk size in GiB for managed node group instances."
  type        = number
  default     = 20
}

variable "eks_node_desired_size" {
  description = "Desired node count."
  type        = number
  default     = 1
}

variable "eks_node_min_size" {
  description = "Minimum node count."
  type        = number
  default     = 1
}

variable "eks_node_max_size" {
  description = "Maximum node count."
  type        = number
  default     = 2
}

variable "enable_frontend_hosting" {
  description = "When true, create the frontend static hosting stack."
  type        = bool
  default     = false
}

variable "frontend_bucket_name" {
  description = "Optional explicit S3 bucket name for frontend assets."
  type        = string
  default     = ""
}

variable "frontend_aliases" {
  description = "Optional CloudFront aliases. Requires an ACM certificate in us-east-1."
  type        = list(string)
  default     = []
}

variable "frontend_acm_certificate_arn" {
  description = "Optional ACM certificate ARN for a custom frontend domain."
  type        = string
  default     = null
}

variable "frontend_price_class" {
  description = "CloudFront price class for the frontend distribution."
  type        = string
  default     = "PriceClass_200"
}

variable "frontend_enable_spa_routing" {
  description = "Map 403 and 404 errors to index.html for single-page app routing."
  type        = bool
  default     = true
}
