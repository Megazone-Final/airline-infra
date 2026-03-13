variable "aws_region" {
  description = "AWS region for the VPC."
  type        = string
  default     = "ap-northeast-2"
}

variable "region_code" {
  description = "Short region code used in the resource naming convention."
  type        = string
  default     = "an2"
}

variable "project" {
  description = "Project name used in resource tags."
  type        = string
  default     = "airline"
}

variable "environment" {
  description = "Environment name used in resource tags."
  type        = string
  default     = "prod"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/24"
}

variable "azs" {
  description = "Availability zones used for the VPC subnets."
  type        = map(string)
  default = {
    "2a" = "ap-northeast-2a"
    "2c" = "ap-northeast-2c"
  }
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
  default = {
    edge_public_2a  = "10.0.0.0/27"
    edge_public_2c  = "10.0.0.32/27"
    node_private_2a = "10.0.0.64/26"
    node_private_2c = "10.0.0.128/26"
    db_private_2a   = "10.0.0.192/28"
    db_private_2c   = "10.0.0.208/28"
  }
}

variable "pod_secondary_cidr" {
  description = "Secondary CIDR block associated with the VPC for pod networking."
  type        = string
  default     = "100.64.0.0/23"
}

variable "pod_subnet_cidrs" {
  description = "Pod subnet CIDRs from the secondary VPC CIDR."
  type = object({
    pod_private_2a = string
    pod_private_2c = string
  })
  default = {
    pod_private_2a = "100.64.0.0/24"
    pod_private_2c = "100.64.1.0/24"
  }
}

variable "alb_cluster_name" {
  description = "EKS cluster name used for optional AWS Load Balancer Controller subnet discovery tag."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Additional tags applied to the VPC."
  type        = map(string)
  default     = {}
}
