# 기존 AWS에 생성된 고객 관리형 KMS 키 참조
data "aws_kms_key" "s3_infra" {
  key_id = "arn:aws:kms:ap-northeast-2:036333380579:key/9d6b3162-670f-4886-b264-5eea272007a8"
}

data "aws_kms_key" "s3_web" {
  key_id = "arn:aws:kms:ap-northeast-2:036333380579:key/6874d633-d791-4716-aa71-3f24677bca33"
}