resoure "aws_s3_bucket" "airline_grafana_logs" {
    bucket = "s3-an2-airline-logs"
    
    tags = {
        Name = "s3-an2-airline-logs"
    }
}

resouce "aws_s3_bucket_versioning" "airline_grafana_logs" {
    bucket = aws_s3_bucket.airline_grafana_logs.id

    versioning_configuration {
        status = "Disabled"
    }
}

resouce "aws_s3_bucket_server_side_encryption_configuration" "airline_grafana_logs" {
    bucket = aws_s3_bucket.airline_grafana_logs.id

    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "SSE-KMS"
        }
    }
}