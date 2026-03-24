# -------------------------------------------------------
# Common Resource: Subnet Group
# -------------------------------------------------------
resource "aws_elasticache_subnet_group" "valkey_subnet_group" {
  name        = local.names.subnet_group
  description = "Valkey shared subnet group"
  subnet_ids  = var.subnet_ids

  tags = merge(var.tags, {
    Name = local.names.subnet_group
  })
}

# -------------------------------------------------------
# 1. Session Valkey Cluster (Password-based authentication)
# -------------------------------------------------------

# Session User (Password auth)
resource "aws_elasticache_user" "valkey_session_user" {
  user_id       = local.names.session_user
  user_name     = local.names.session_user
  engine        = "valkey"
  access_string = "on ~* +@all -flushall -flushdb"

  authentication_mode {
    type      = "password"
    passwords = [var.session_password]
  }
}

# Session User Group
resource "aws_elasticache_user_group" "valkey_session_ug" {
  engine        = "valkey"
  user_group_id = local.names.session_ug

  user_ids = [
    "default",
    aws_elasticache_user.valkey_session_user.user_id,
  ]

  lifecycle {
    ignore_changes = [user_ids]
  }
}

resource "aws_elasticache_replication_group" "valkey-an2-airline-session" {
  replication_group_id = local.names.session_cluster
  description          = "Login session cache"
  engine               = "valkey"
  engine_version       = "8.2"
  port                 = 6379
  parameter_group_name = "default.valkey8"
  node_type            = "cache.t4g.micro"

  num_cache_clusters         = 1
  multi_az_enabled           = false
  automatic_failover_enabled = false
  cluster_mode               = "disabled"

  subnet_group_name  = aws_elasticache_subnet_group.valkey_subnet_group.name
  security_group_ids = var.security_group_ids

  transit_encryption_enabled = true

  user_group_ids = [
    aws_elasticache_user_group.valkey_session_ug.user_group_id,
  ]

  tags = merge(var.tags, {
    Name = local.names.session_cluster
  })

  depends_on = [
    aws_elasticache_subnet_group.valkey_subnet_group,
    aws_elasticache_user_group.valkey_session_ug
  ]
}

# -------------------------------------------------------
# 2. SVC Valkey Cluster (IAM Authentication with multiple accounts)
# -------------------------------------------------------

# Service Account 1: auth-user (IAM auth)
resource "aws_elasticache_user" "svc_user_auth" {
  user_id       = local.names.svc_user_auth
  user_name     = local.names.svc_user_auth
  engine        = "valkey"
  access_string = "on ~* +@all -flushall -flushdb"

  authentication_mode {
    type = "iam"
  }
}

# Service Account 2: flight-user (IAM auth)
resource "aws_elasticache_user" "svc_user_flight" {
  user_id       = local.names.svc_user_flight
  user_name     = local.names.svc_user_flight
  engine        = "valkey"
  access_string = "on ~* +@all -flushall -flushdb"

  authentication_mode {
    type = "iam"
  }
}

# Service Account 3: payment-user (IAM auth)
resource "aws_elasticache_user" "svc_user_payment" {
  user_id       = local.names.svc_user_payment
  user_name     = local.names.svc_user_payment
  engine        = "valkey"
  access_string = "on ~* +@all -flushall -flushdb"

  authentication_mode {
    type = "iam"
  }
}

# SVC User Group (includes all three service accounts)
resource "aws_elasticache_user_group" "valkey_svc_ug" {
  engine        = "valkey"
  user_group_id = local.names.svc_ug

  user_ids = [
    "default",
    aws_elasticache_user.svc_user_auth.user_id,
    aws_elasticache_user.svc_user_flight.user_id,
    aws_elasticache_user.svc_user_payment.user_id,
  ]

  lifecycle {
    ignore_changes = [user_ids]
  }
}

# SVC Cluster
resource "aws_elasticache_replication_group" "valkey-an2-airline-svc" {
  replication_group_id = local.names.svc_cluster
  description          = "Backend SVC cache for airline"
  engine               = "valkey"
  engine_version       = "8.2"
  port                 = 6379
  parameter_group_name = "default.valkey8"
  node_type            = "cache.t4g.micro"

  num_cache_clusters         = 1
  multi_az_enabled           = false
  automatic_failover_enabled = false
  cluster_mode               = "disabled"

  subnet_group_name  = aws_elasticache_subnet_group.valkey_subnet_group.name
  security_group_ids = var.security_group_ids

  transit_encryption_enabled = true

  user_group_ids = [
    aws_elasticache_user_group.valkey_svc_ug.user_group_id,
  ]

  tags = merge(var.tags, {
    Name = local.names.svc_cluster
  })

  depends_on = [
    aws_elasticache_subnet_group.valkey_subnet_group,
    aws_elasticache_user_group.valkey_svc_ug
  ]
}
