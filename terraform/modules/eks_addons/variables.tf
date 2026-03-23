variable "cluster_name" {
  description = "Name of the shared EKS cluster."
  type        = string
}

variable "cluster_endpoint" {
  description = "Endpoint for the shared EKS Kubernetes API server."
  type        = string
}

variable "node_security_group_id" {
  description = "Node security group ID used by worker nodes and pod ENIs."
  type        = string
}

variable "node_subnet_ids" {
  description = "Ordered list of node subnet IDs used by Karpenter."
  type        = list(string)
}

variable "pod_eni_configs" {
  description = "Map of availability zone name to pod subnet ID used by ENIConfig."
  type        = map(string)
}

variable "eks_karpenter_chart_version" {
  description = "Pinned Karpenter Helm chart version."
  type        = string
}

variable "eks_karpenter_namespace" {
  description = "Namespace where Karpenter is deployed."
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

variable "eks_karpenter_ami_alias" {
  description = "Karpenter AMI alias used when a fixed AMI ID is not supplied."
  type        = string
}

variable "eks_karpenter_ami_id" {
  description = "Optional fixed AMI ID for Karpenter nodes."
  type        = string
  default     = null
  nullable    = true
}

variable "eks_karpenter_instance_categories" {
  description = "Instance categories allowed by the default Karpenter NodePool."
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

variable "karpenter_interruption_queue_name" {
  description = "SQS queue name used by Karpenter interruption handling."
  type        = string
}

variable "karpenter_node_iam_role_name" {
  description = "IAM role name used by nodes launched through Karpenter."
  type        = string
}

variable "karpenter_node_class_name" {
  description = "Default EC2NodeClass name for Karpenter."
  type        = string
}

variable "karpenter_node_pool_name" {
  description = "Default NodePool name for Karpenter."
  type        = string
}

variable "karpenter_node_name" {
  description = "Name tag applied to Karpenter-created nodes."
  type        = string
}

variable "tags" {
  description = "Common tags applied to Karpenter-created AWS resources."
  type        = map(string)
  default     = {}
}
