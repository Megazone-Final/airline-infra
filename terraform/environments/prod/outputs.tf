# Disabled reference file.
# Active VPC output file: outputs-vpc.tf
#
# This file is kept only so you can compare the old generic naming
# (`outputs.tf`) with the new VPC-specific layout.
#
# output "vpc_id" {
#   description = "ID of the shared VPC."
#   value       = module.vpc.id
# }
#
# output "private_subnet_ids" {
#   description = "Private subnet IDs for application workloads."
#   value       = module.vpc.private_subnet_ids
# }
#
# output "public_subnet_ids" {
#   description = "Public subnet IDs for ingress and public endpoints."
#   value       = module.vpc.public_subnet_ids
# }
