resource "aws_s3_bucket" "airline_grafana_logs" {
  bucket = "s3-an2-airline-logs"

  tags = {
    Name = "s3-an2-airline-logs"
  }
}

resource "aws_s3_bucket_versioning" "airline_grafana_logs" {
  bucket = aws_s3_bucket.airline_grafana_logs.id

  versioning_configuration {
    status = "Suspended"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "airline_grafana_logs" {
  bucket = aws_s3_bucket.airline_grafana_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "airline_grafana_logs" {
  bucket = aws_s3_bucket.airline_grafana_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
