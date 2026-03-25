locals {
  rds_allowed_cidr_blocks = ["100.64.0.0/24", "100.64.1.0/24"]
}

# -------------------------------------------------------
# RDS Security Groups
# -------------------------------------------------------

# 1. 프록시용 보안 그룹 (애플리케이션이 프록시에 붙을 수 있게 허용)
resource "aws_security_group" "rds_proxy_sg" {
  name        = "proxy-${var.project_name}-sg"
  description = "Security group for RDS Proxy"
  vpc_id      = module.vpc.id

  ingress {
    description = "Allow MySQL from EKS Pods and inner VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = local.rds_allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "proxy-${var.project_name}-sg"
  })
}

# 2. 클러스터용 보안 그룹 (오직 프록시에서 오는 트래픽만 허용!)
resource "aws_security_group" "rds_db_sg" {
  name        = "rds-${var.project_name}-sg"
  description = "Security group for RDS Cluster"
  vpc_id      = module.vpc.id

  # 이 설정 덕분에 DB 클러스터는 프록시 거치지 않고서는 절대 접근할 수 없습니다
  ingress {
    description     = "Allow MySQL only from RDS Proxy"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.rds_proxy_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "rds-${var.project_name}-sg"
  })
}

# -------------------------------------------------------
# RDS Module
# -------------------------------------------------------
module "rds" {
  source = "../../modules/rds"

  # Naming convention variables
  region_code  = var.region_code
  project_name = var.project_name

  # Network resources (Referencing the VPC module output dynamically)
  subnet_ids = values(module.vpc.db_private_subnet_ids)

  # 방금 위에서 만든 보안 그룹을 바로 주입 (하드코딩 제거 완료!)
  vpc_security_group_ids = [aws_security_group.rds_db_sg.id]

  # Proxy Settings
  proxy_subnet_ids = values(module.vpc.private_subnet_ids)
  # 방금 위에서 만든 프록시용 보안 그룹 주입
  proxy_security_group_ids = [aws_security_group.rds_proxy_sg.id]

  # Common tags
  tags = local.common_tags
}
