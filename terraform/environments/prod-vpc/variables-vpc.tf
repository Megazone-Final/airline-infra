variable "project_name" {
  description = "Project name used for resource naming."
  type        = string
  default     = "airline"
}

variable "region_code" {
  description = "Short region code used in the resource naming convention."
  type        = string
  default     = "an2"
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

variable "cidr_block" {
  description = "CIDR block for the shared VPC."
  type        = string
  default     = "10.0.0.0/24"
}

variable "azs" {
  description = "Availability zones keyed by short suffix."
  type        = map(string)
  default = {
    "2a" = "ap-northeast-2a"
    "2c" = "ap-northeast-2c"
  }
}

variable "pod_secondary_cidr" {
  description = "Secondary CIDR block associated with the VPC for pod networking."
  type        = string
  default     = "100.64.0.0/20"
}

variable "subnets" {
  description = "Subnet topology for the shared VPC."
  type = map(object({
    name                    = string
    cidr_block              = string
    availability_zone       = string
    tier                    = string
    role                    = string
    route_table             = string
    map_public_ip_on_launch = bool
    address_family          = string
  }))
  default = {
    edge_public_2a = {
      name                    = "subnet-an2-airline-edge-pub-2a"
      cidr_block              = "10.0.0.0/27"
      availability_zone       = "ap-northeast-2a"
      tier                    = "public"
      role                    = "edge"
      route_table             = "public"
      map_public_ip_on_launch = true
      address_family          = "primary"
    }
    edge_public_2c = {
      name                    = "subnet-an2-airline-edge-pub-2c"
      cidr_block              = "10.0.0.32/27"
      availability_zone       = "ap-northeast-2c"
      tier                    = "public"
      role                    = "edge"
      route_table             = "public"
      map_public_ip_on_launch = true
      address_family          = "primary"
    }
    node_private_2a = {
      name                    = "subnet-an2-airline-node-pri-2a"
      cidr_block              = "10.0.0.64/26"
      availability_zone       = "ap-northeast-2a"
      tier                    = "private"
      role                    = "node"
      route_table             = "private"
      map_public_ip_on_launch = false
      address_family          = "primary"
    }
    node_private_2c = {
      name                    = "subnet-an2-airline-node-pri-2c"
      cidr_block              = "10.0.0.128/26"
      availability_zone       = "ap-northeast-2c"
      tier                    = "private"
      role                    = "node"
      route_table             = "private"
      map_public_ip_on_launch = false
      address_family          = "primary"
    }
    db_private_2a = {
      name                    = "subnet-an2-airline-db-pri-2a"
      cidr_block              = "10.0.0.192/28"
      availability_zone       = "ap-northeast-2a"
      tier                    = "private"
      role                    = "db"
      route_table             = "db_private"
      map_public_ip_on_launch = false
      address_family          = "primary"
    }
    db_private_2c = {
      name                    = "subnet-an2-airline-db-pri-2c"
      cidr_block              = "10.0.0.208/28"
      availability_zone       = "ap-northeast-2c"
      tier                    = "private"
      role                    = "db"
      route_table             = "db_private"
      map_public_ip_on_launch = false
      address_family          = "primary"
    }
    pod_private_2a = {
      name                    = "subnet-an2-airline-pod-pri-2a"
      cidr_block              = "100.64.0.0/21"
      availability_zone       = "ap-northeast-2a"
      tier                    = "private"
      role                    = "pod"
      route_table             = "pod_private"
      map_public_ip_on_launch = false
      address_family          = "secondary"
    }
    pod_private_2c = {
      name                    = "subnet-an2-airline-pod-pri-2c"
      cidr_block              = "100.64.8.0/21"
      availability_zone       = "ap-northeast-2c"
      tier                    = "private"
      role                    = "pod"
      route_table             = "pod_private"
      map_public_ip_on_launch = false
      address_family          = "secondary"
    }
  }
}

variable "enable_kubernetes_subnet_tags" {
  description = "Whether to add Kubernetes subnet discovery tags for the EKS cluster."
  type        = bool
  default     = true
}

variable "eks_cluster_name_override" {
  description = "Optional explicit EKS cluster name used for subnet discovery tags."
  type        = string
  default     = ""
}
