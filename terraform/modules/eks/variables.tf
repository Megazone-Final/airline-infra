variable "enabled" {
  description = "When true, create the EKS cluster and node group."
  type        = bool
  default     = true
}

variable "name" {
  description = "Cluster name."
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the cluster runs."
  type        = string
}

variable "subnet_ids" {
  description = "Private subnet IDs for the control plane and node group."
  type        = list(string)
}

variable "kubernetes_service_ipv4_cidr" {
  description = "Service CIDR for the cluster."
  type        = string
}

variable "endpoint_public_access" {
  description = "Enable public access to the EKS API endpoint."
  type        = bool
  default     = true
}

variable "endpoint_private_access" {
  description = "Enable private access to the EKS API endpoint."
  type        = bool
  default     = true
}

variable "endpoint_public_access_cidrs" {
  description = "CIDR blocks allowed to access the public EKS API endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "cluster_log_types" {
  description = "Enabled EKS control plane log types."
  type        = list(string)
  default     = []
}

variable "cloudwatch_log_retention_in_days" {
  description = "Retention for EKS log groups."
  type        = number
  default     = 7
}

variable "node_group_name" {
  description = "Managed node group suffix."
  type        = string
  default     = "default"
}

variable "node_group_instance_types" {
  description = "Instance types for the managed node group."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_group_capacity_type" {
  description = "Capacity type for the managed node group."
  type        = string
  default     = "ON_DEMAND"
}

variable "node_group_disk_size" {
  description = "Disk size in GiB for node group instances."
  type        = number
  default     = 20
}

variable "node_group_desired_size" {
  description = "Desired node count."
  type        = number
  default     = 1
}

variable "node_group_min_size" {
  description = "Minimum node count."
  type        = number
  default     = 1
}

variable "node_group_max_size" {
  description = "Maximum node count."
  type        = number
  default     = 2
}

variable "tags" {
  description = "Tags applied to supported resources."
  type        = map(string)
  default     = {}
}
