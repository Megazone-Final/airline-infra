variable "region_code" {
  description = "Short region code used in resource naming."
  type        = string
}

variable "project_name" {
  description = "Project name used in resource naming."
  type        = string
}

variable "cidr_block" {
  description = "Primary CIDR block for the VPC."
  type        = string
}

variable "azs" {
  description = "Map of short AZ suffixes to AWS Availability Zone names."
  type        = map(string)
}

variable "subnet_cidrs" {
  description = "CIDR ranges for subnets created from the primary VPC CIDR."
  type = object({
    edge_public_2a  = string
    edge_public_2c  = string
    node_private_2a = string
    node_private_2c = string
    db_private_2a   = string
    db_private_2c   = string
  })
}

variable "pod_secondary_cidr" {
  description = "Secondary VPC CIDR block reserved for pod networking."
  type        = string
}

variable "pod_subnet_cidrs" {
  description = "CIDR ranges for pod subnets carved from the secondary VPC CIDR."
  type = object({
    pod_private_2a = string
    pod_private_2c = string
  })
}

variable "alb_cluster_name" {
  description = "Optional EKS cluster name used for ALB Controller subnet discovery tags."
  type        = string
  default     = ""
}

variable "enable_dns_support" {
  description = "Whether DNS resolution is enabled for the VPC."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Whether instances in the VPC receive public DNS hostnames."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common tags applied to VPC-related resources."
  type        = map(string)
  default     = {}
}
