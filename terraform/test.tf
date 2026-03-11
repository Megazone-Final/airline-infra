# 테스트용 — 워크플로우 동작 확인 후 삭제
resource "aws_s3_bucket" "test" {
  bucket = "s3-an2-airline-infra-test-${random_id.suffix.hex}"

  tags = {
    Name        = "terraform-test"
    Environment = "test"
    ManagedBy   = "terraform"
  }
}

resource "random_id" "suffix" {
  byte_length = 5
}

output "test_bucket_name" {
  value = aws_s3_bucket.test.bucket
}
