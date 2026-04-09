variable "region_code" {
  description = "Short region code used in the resource naming convention."
  type        = string
}

variable "project_name" {
  description = "Project name used in the resource naming convention."
  type        = string
}

variable "alb_cluster_name" {
  description = "Optional cluster name override shared with ALB subnet tagging."
  type        = string
  default     = ""
}

variable "azs" {
  description = "Availability zones keyed by short suffix."
  type        = map(string)
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster runs."
  type        = string
}

variable "node_private_subnet_ids" {
  description = "Map of node subnet keys to subnet IDs."
  type        = map(string)
}

variable "pod_private_subnet_ids" {
  description = "Map of pod subnet keys to subnet IDs."
  type        = map(string)
}

variable "cluster_admin_principal_arns" {
  description = "IAM principal ARNs granted cluster-admin access before in-cluster resources are applied."
  type        = map(string)
  default     = {}
}

variable "cluster_admin_access_ready_wait_duration" {
  description = "Maximum time Terraform waits for cluster-admin access to become usable before applying in-cluster resources."
  type        = string
  default     = "60s"
}

variable "eks_api_allowed_security_group_ids" {
  description = "Additional security group IDs allowed to reach the private EKS API endpoint on port 443."
  type        = list(string)
  default     = []
}

variable "eks_cluster_version" {
  description = "Kubernetes version for the shared EKS cluster."
  type        = string
}

variable "eks_service_ipv4_cidr" {
  description = "Service CIDR block for the EKS cluster."
  type        = string
}

variable "eks_endpoint_public_access" {
  description = "Whether the EKS API server is reachable through the public endpoint."
  type        = bool
}

variable "eks_endpoint_private_access" {
  description = "Whether the EKS API server is reachable through the private endpoint."
  type        = bool
}

variable "eks_endpoint_public_access_cidrs" {
  description = "CIDR blocks allowed to reach the public EKS API endpoint."
  type        = list(string)
}

variable "eks_enabled_log_types" {
  description = "Control plane log types enabled for the EKS cluster."
  type        = list(string)
}

variable "eks_cloudwatch_log_retention_in_days" {
  description = "Retention period for EKS control plane logs in CloudWatch."
  type        = number
}

variable "eks_managed_node_group_ami_type" {
  description = "AMI type used by the EKS managed node groups."
  type        = string
}

variable "eks_managed_node_groups" {
  description = "Managed node groups keyed by logical role such as system or platform."
  type = map(object({
    subnet_ids     = list(string)
    instance_types = list(string)
    capacity_type  = string
    disk_size      = number
    desired_size   = number
    min_size       = number
    max_size       = number
    labels         = optional(map(string), {})
    taints = optional(map(object({
      key    = string
      value  = string
      effect = string
    })), {})
  }))
}

variable "eks_karpenter_namespace" {
  description = "Namespace where Karpenter is deployed."
  type        = string
}

variable "eks_karpenter_chart_version" {
  description = "Pinned Karpenter Helm chart version."
  type        = string
}

variable "eks_karpenter_service_account_name" {
  description = "Service account name used by the Karpenter controller."
  type        = string
}

variable "eks_karpenter_ami_family" {
  description = "AMI family used by the Karpenter EC2NodeClass."
  type        = string
}

variable "eks_karpenter_ami_id" {
  description = "Optional fixed AMI ID for Karpenter nodes. Leave null to use the same EKS optimized AMI as the managed node group."
  type        = string
  default     = null
  nullable    = true
}

variable "eks_karpenter_instance_types" {
  description = "Instance types allowed by the default Karpenter NodePool."
  type        = list(string)
}

variable "eks_karpenter_architectures" {
  description = "CPU architectures allowed by the default Karpenter NodePool."
  type        = list(string)
}

variable "eks_karpenter_capacity_types" {
  description = "Capacity types allowed by the default Karpenter NodePool."
  type        = list(string)
}

variable "eks_karpenter_consolidation_policy" {
  description = "Karpenter disruption consolidation policy for the default NodePool."
  type        = string
}

variable "eks_karpenter_consolidate_after" {
  description = "Duration Karpenter waits before consolidating nodes."
  type        = string
}

variable "eks_vpc_cni_warm_prefix_target" {
  description = "WARM_PREFIX_TARGET value for the VPC CNI addon."
  type        = number
}

variable "tags" {
  description = "Common tags applied to EKS-related resources."
  type        = map(string)
  default     = {}
}
