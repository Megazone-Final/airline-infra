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

variable "pod_secondary_cidr" {
  description = "Secondary VPC CIDR block reserved for pod networking."
  type        = string
}

variable "subnets" {
  description = "Subnet definitions keyed by logical subnet name."
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

variable "subnet_tags" {
  description = "Additional tags applied per subnet key."
  type        = map(map(string))
  default     = {}
}
