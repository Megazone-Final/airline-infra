variable "enabled" {
  description = "When true, create the VPC and related networking resources."
  type        = bool
  default     = true
}

variable "name" {
  description = "Base name used for VPC resource naming."
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "azs" {
  description = "Availability zones for subnet creation."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks."
  type        = list(string)
}

variable "create_nat_gateway" {
  description = "Create a single shared NAT gateway."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to supported resources."
  type        = map(string)
  default     = {}
}
