variable "region_code" {
  description = "Short region code used in the resource naming convention."
  type        = string
}

variable "project_name" {
  description = "Project name used in the resource naming convention."
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "azs" {
  description = "Availability zones keyed by short suffix (e.g. 2a, 2c)."
  type        = map(string)
}

variable "subnet_cidrs" {
  description = "Primary VPC subnet CIDRs."
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
  description = "Secondary CIDR block for pod subnets."
  type        = string
}

variable "pod_subnet_cidrs" {
  description = "Pod subnet CIDRs from the secondary VPC CIDR."
  type = object({
    pod_private_2a = string
    pod_private_2c = string
  })
}

variable "alb_cluster_name" {
  description = "EKS cluster name used for optional subnet discovery tag."
  type        = string
  default     = ""
}

variable "enable_dns_support" {
  description = "Whether the VPC supports DNS resolution."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Whether instances in the VPC get public DNS hostnames."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to the VPC."
  type        = map(string)
  default     = {}
}
