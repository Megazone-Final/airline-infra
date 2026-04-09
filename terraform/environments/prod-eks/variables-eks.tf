variable "eks_cluster_version" {
  description = "Kubernetes version for the shared EKS cluster."
  type        = string
  default     = "1.35"
}

variable "eks_service_ipv4_cidr" {
  description = "Service CIDR block for the EKS cluster."
  type        = string
  default     = "172.20.0.0/16"
}

variable "eks_endpoint_public_access" {
  description = "Whether the EKS API server is reachable through the public endpoint."
  type        = bool
  default     = false
}

variable "eks_endpoint_private_access" {
  description = "Whether the EKS API server is reachable through the private endpoint."
  type        = bool
  default     = true
}

variable "eks_endpoint_public_access_cidrs" {
  description = "CIDR blocks allowed to reach the public EKS API endpoint."
  type        = list(string)
  default     = []
}

variable "eks_enabled_log_types" {
  description = "Control plane log types enabled for the EKS cluster."
  type        = list(string)
  default     = ["api", "audit", "authenticator"]
}

variable "eks_cloudwatch_log_retention_in_days" {
  description = "Retention period for EKS control plane logs in CloudWatch."
  type        = number
  default     = 7
}

variable "eks_managed_node_group_ami_type" {
  description = "AMI type used by the EKS managed node groups."
  type        = string
  default     = "AL2023_x86_64_STANDARD"
}

variable "eks_managed_node_groups" {
  description = "Managed node groups keyed by role."
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
  default = {
    system = {
      subnet_ids     = ["subnet-0a9c6410e9a9cba94", "subnet-0b2a66b3bb0697783"]
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
      disk_size      = 20
      desired_size   = 2
      min_size       = 2
      max_size       = 3
      labels = {
        role                      = "system"
        "karpenter.sh/controller" = "true"
      }
      taints = {}
    }
    platform = {
      subnet_ids     = ["subnet-0a9c6410e9a9cba94", "subnet-0b2a66b3bb0697783"]
      instance_types = ["t3.xlarge"]
      capacity_type  = "ON_DEMAND"
      disk_size      = 50
      desired_size   = 2
      min_size       = 2
      max_size       = 3
      labels = {
        role = "platform"
      }
      taints = {
        dedicated = {
          key    = "dedicated"
          value  = "platform"
          effect = "NO_SCHEDULE"
        }
      }
    }
  }
}

variable "eks_pod_private_subnet_ids" {
  description = "Pod subnet IDs used by EKS custom networking ENIConfig."
  type        = map(string)
  default = {
    pod_private_2a = "subnet-072160d5a1806dcfb"
    pod_private_2c = "subnet-00955cad282a63da1"
  }
}

variable "eks_karpenter_chart_version" {
  description = "Pinned Karpenter Helm chart version."
  type        = string
  default     = "1.6.0"
}

variable "eks_karpenter_namespace" {
  description = "Namespace where Karpenter is deployed."
  type        = string
  default     = "karpenter"
}

variable "eks_karpenter_service_account_name" {
  description = "Service account name used by the Karpenter controller."
  type        = string
  default     = "karpenter"
}

variable "eks_karpenter_ami_family" {
  description = "AMI family used by the Karpenter EC2NodeClass."
  type        = string
  default     = "AL2023"
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
  default     = ["c7i.large", "c7i.xlarge", "c7i.2xlarge"]
}

variable "eks_karpenter_architectures" {
  description = "CPU architectures allowed by the default Karpenter NodePool."
  type        = list(string)
  default     = ["amd64"]
}

variable "eks_karpenter_capacity_types" {
  description = "Capacity types allowed by the default Karpenter NodePool."
  type        = list(string)
  default     = ["on-demand"]
}

variable "eks_karpenter_consolidation_policy" {
  description = "Karpenter disruption consolidation policy for the default NodePool."
  type        = string
  default     = "WhenEmptyOrUnderutilized"
}

variable "eks_karpenter_consolidate_after" {
  description = "Duration Karpenter waits before consolidating nodes."
  type        = string
  default     = "30s"
}

variable "eks_vpc_cni_warm_prefix_target" {
  description = "WARM_PREFIX_TARGET value for the VPC CNI addon."
  type        = number
  default     = 1
}
