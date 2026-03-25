# -------------------------------------------------------
# RDS Subnet Group
# -------------------------------------------------------
resource "aws_db_subnet_group" "subnet_group" {
  name        = local.names.subnet_group
  description = "RDS DB subnet group spanning 2 AZs"
  subnet_ids  = var.subnet_ids

  tags = merge(var.tags, {
    Name = local.names.subnet_group
  })
}

# -------------------------------------------------------
# RDS Aurora Cluster
# -------------------------------------------------------
resource "aws_rds_cluster" "main" {
  cluster_identifier = local.names.cluster_identifier
  engine             = "aurora-mysql"
  engine_version     = "8.0.mysql_aurora.3.10.3"
  engine_mode        = "provisioned"
  port               = 3306

  master_username                     = "admin"
  iam_database_authentication_enabled = true
  manage_master_user_password         = true # AWS Secrets Manager 통합 (Terraform 기본 권장)

  db_subnet_group_name   = aws_db_subnet_group.subnet_group.name
  vpc_security_group_ids = var.vpc_security_group_ids

  storage_type        = "aurora"
  skip_final_snapshot = true

  tags = merge(var.tags, {
    Name = local.names.cluster_identifier
  })
}

# -------------------------------------------------------
# RDS Instances (Primary & Reader)
# -------------------------------------------------------
resource "aws_rds_cluster_instance" "primary" {
  identifier         = local.names.primary_instance
  cluster_identifier = aws_rds_cluster.main.id
  engine             = aws_rds_cluster.main.engine
  engine_version     = aws_rds_cluster.main.engine_version
  instance_class     = "db.t3.medium"

  db_subnet_group_name       = aws_db_subnet_group.subnet_group.name
  publicly_accessible        = false
  auto_minor_version_upgrade = true

  tags = merge(var.tags, {
    Name = local.names.primary_instance
  })
}

resource "aws_rds_cluster_instance" "reader" {
  identifier         = local.names.reader_instance
  cluster_identifier = aws_rds_cluster.main.id
  engine             = aws_rds_cluster.main.engine
  engine_version     = aws_rds_cluster.main.engine_version
  instance_class     = "db.t3.medium"

  db_subnet_group_name       = aws_db_subnet_group.subnet_group.name
  publicly_accessible        = false
  auto_minor_version_upgrade = true

  tags = merge(var.tags, {
    Name = local.names.reader_instance
  })
}

# -------------------------------------------------------
# IAM Role for RDS Proxy
# -------------------------------------------------------
resource "aws_iam_role" "proxy_role" {
  name = "${local.names.proxy_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "rds.amazonaws.com" }
    }]
  })

  tags = merge(var.tags, {
    Name = "${local.names.proxy_name}-role"
  })
}

resource "aws_iam_role_policy" "proxy_policy" {
  name = "secrets-access"
  role = aws_iam_role.proxy_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["secretsmanager:GetSecretValue"]
      Effect   = "Allow"
      Resource = [aws_rds_cluster.main.master_user_secret[0].secret_arn]
    }]
  })
}

# -------------------------------------------------------
# RDS Proxy
# -------------------------------------------------------
resource "aws_db_proxy" "proxy" {
  name                   = local.names.proxy_name
  engine_family          = "MYSQL"
  require_tls            = true
  role_arn               = aws_iam_role.proxy_role.arn
  vpc_security_group_ids = var.proxy_security_group_ids
  vpc_subnet_ids         = var.proxy_subnet_ids

  auth {
    auth_scheme               = "SECRETS"
    client_password_auth_type = "MYSQL_CACHING_SHA2_PASSWORD"
    iam_auth                  = "REQUIRED"
    secret_arn                = aws_rds_cluster.main.master_user_secret[0].secret_arn
  }

  tags = merge(var.tags, {
    Name = local.names.proxy_name
  })
}
