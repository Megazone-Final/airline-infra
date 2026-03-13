# Disabled reference file.
# Active VPC variable file: variables-vpc.tf

# This file is kept only so you can compare the old generic naming
# (`variables.tf`) with the new VPC-specific layout.

# variable "project_name" {
#   description = "Project name used for resource naming."
#   type        = string
#   default     = "airline"
# }

# variable "region_code" {
#   description = "Short region code used in the resource naming convention."
#   type        = string
#   default     = "an2"
# }

# variable "environment" {
#   description = "Logical environment name."
#   type        = string
#   default     = "prod"
# }

# variable "tags" {
#   description = "Additional tags applied to supported resources."
#   type        = map(string)
#   default     = {}
# }

# variable "cidr_block" {
#   description = "CIDR block for the shared VPC."
#   type        = string
#   default     = "10.0.0.0/24"
# }

# variable "azs" {
#   description = "Availability zones keyed by short suffix."
#   type        = map(string)
#   default = {
#     "2a" = "ap-northeast-2a"
#     "2c" = "ap-northeast-2c"
#   }
# }

# variable "subnet_cidrs" {
#   description = "Primary VPC subnet CIDRs keyed by subnet role and AZ."
#   type = object({
#     edge_public_2a  = string
#     edge_public_2c  = string
#     node_private_2a = string
#     node_private_2c = string
#     db_private_2a   = string
#     db_private_2c   = string
#   })
#   default = {
#     edge_public_2a  = "10.0.0.0/27"
#     edge_public_2c  = "10.0.0.32/27"
#     node_private_2a = "10.0.0.64/26"
#     node_private_2c = "10.0.0.128/26"
#     db_private_2a   = "10.0.0.192/28"
#     db_private_2c   = "10.0.0.208/28"
#   }
# }

# variable "pod_secondary_cidr" {
#   description = "Secondary CIDR block associated with the VPC for pod networking."
#   type        = string
#   default     = "100.64.0.0/23"
# }

# variable "pod_subnet_cidrs" {
#   description = "Pod subnet CIDRs carved from the secondary VPC CIDR."
#   type = object({
#     pod_private_2a = string
#     pod_private_2c = string
#   })
#   default = {
#     pod_private_2a = "100.64.0.0/24"
#     pod_private_2c = "100.64.1.0/24"
#   }
# }
