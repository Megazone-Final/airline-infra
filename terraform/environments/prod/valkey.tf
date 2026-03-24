# -------------------------------------------------------
# Valkey Security Group
# -------------------------------------------------------
resource "aws_security_group" "valkey_sg" {
  name        = "valkey-${var.project_name}-sg"
  description = "Security group for Valkey Caches"
  vpc_id      = module.vpc.id

  ingress {
    description = "Allow Valkey from EKS Pods and inner VPC"
    from_port   = 6379
    to_port     = 6380   # Valkey Session(6379) or maybe auth uses other? We just open 6379-6380
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16", "100.64.0.0/16"]
  }

  tags = merge(local.common_tags, {
    Name = "valkey-${var.project_name}-sg"
  })
}

# -------------------------------------------------------
# Valkey Module
# -------------------------------------------------------
module "valkey" {
  source = "../../modules/valkey"

  # Naming convention variables
  region_code  = var.region_code
  project_name = var.project_name

  # Network resources (dynamically referenced from VPC module)
  subnet_ids = values(module.vpc.db_private_subnet_ids)

  # Valkey security group (Auto-generated above)
  security_group_ids = [aws_security_group.valkey_sg.id]

  # Authentication
  session_password = var.valkey_session_password

  # Common tags
  tags = local.common_tags
}
