resource "aws_ecr_repository" "this" {
  for_each = var.enabled ? toset(var.repository_names) : toset([])

  name                 = each.value
  image_tag_mutability = var.image_tag_mutability

  encryption_configuration {
    encryption_type = "KMS"
  }

  tags = merge(var.tags, {
    Name = each.value
  })
}

# 레지스트리 수준 스캐닝이 deprecated 된 리포지토리 수준 scan_on_push 설정을 대체합니다.
resource "aws_ecr_registry_scanning_configuration" "this" {
  count = var.enabled ? 1 : 0

  scan_type = "BASIC"

  dynamic "rule" {
    for_each = var.scan_on_push ? [1] : []

    content {
      scan_frequency = "SCAN_ON_PUSH"

      dynamic "repository_filter" {
        for_each = toset(var.repository_names)

        content {
          filter      = repository_filter.value
          filter_type = "WILDCARD"
        }
      }
    }
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  for_each = aws_ecr_repository.this

  repository = each.value.name
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire images beyond the most recent tagged set"
        selection = {
          tagStatus   = "tagged"
          countType   = "imageCountMoreThan"
          countNumber = var.keep_last_images
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
