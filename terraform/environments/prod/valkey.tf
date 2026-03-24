module "valkey" {
  source = "../../modules/valkey"

  # Naming convention variables
  region_code  = var.region_code
  project_name = var.project_name

  # Network resources (manually provided subnets for testing and console)
  subnet_ids = [
    "subnet-099c622a9800f4153", # Terraform generated subnet
    "subnet-0284ea5133aa8e28e"  # Console generated subnet
  ]

  # Valkey security group
  security_group_ids = [
    "sg-05859beb7dce28b04" 
  ]

  # Authentication
  session_password = var.valkey_session_password

  # Common tags
  tags = local.common_tags
}
