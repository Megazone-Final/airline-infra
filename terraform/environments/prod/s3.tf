# ==============================================================================
# grafana_logs
# ==============================================================================
resource "aws_s3_bucket" "airline_grafana_logs" {
  count  = var.s3_logs_enabled ? 1 : 0
  bucket = "s3-an2-airline-logs"

  tags = {
    Name = "s3-an2-airline-logs"
  }
}

resource "aws_s3_bucket_versioning" "airline_grafana_logs" {
  count  = var.s3_logs_enabled ? 1 : 0
  bucket = aws_s3_bucket.airline_grafana_logs[0].id

  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "airline_grafana_logs" {
  count  = var.s3_logs_enabled ? 1 : 0
  bucket = aws_s3_bucket.airline_grafana_logs[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "airline_grafana_logs" {
  count = var.s3_logs_enabled ? 1 : 0

  bucket                  = aws_s3_bucket.airline_grafana_logs[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ==============================================================================
# airline_infra
# ==============================================================================

resource "aws_s3_bucket" "airline_infra" {
  count  = var.s3_infra_enabled ? 1 : 0
  bucket = "s3-an2-airline-infra"

  tags = {
    Name = "s3-an2-airline-infra"
  }
}

resource "aws_s3_bucket_versioning" "airline_infra" {
  count  = var.s3_infra_enabled ? 1 : 0
  bucket = aws_s3_bucket.airline_infra[0].id

  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "airline_infra" {
  count  = var.s3_infra_enabled ? 1 : 0
  bucket = aws_s3_bucket.airline_infra[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = data.aws_kms_key.s3_infra.arn
    }
  }
}

resource "aws_s3_bucket_public_access_block" "airline_infra" {
  count = var.s3_infra_enabled ? 1 : 0

  bucket                  = aws_s3_bucket.airline_infra[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ==============================================================================
# airline_web
# ==============================================================================

resource "aws_s3_bucket" "airline_web" {
  count  = var.s3_web_enabled ? 1 : 0
  bucket = "s3-an2-airline-web"

  tags = {
    Name = "s3-an2-airline-web"
  }
}

resource "aws_s3_bucket_versioning" "airline_web" {
  count  = var.s3_web_enabled ? 1 : 0
  bucket = aws_s3_bucket.airline_web[0].id

  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "airline_web" {
  count  = var.s3_web_enabled ? 1 : 0
  bucket = aws_s3_bucket.airline_web[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = data.aws_kms_key.s3_web.arn
    }
  }
}

resource "aws_s3_bucket_public_access_block" "airline_web" {
  count = var.s3_web_enabled ? 1 : 0

  bucket                  = aws_s3_bucket.airline_web[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

