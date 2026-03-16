module "ecr" {
  source = "../../modules/ecr"

  enabled              = var.ecr_enabled
  repository_names     = var.ecr_repository_names
  image_tag_mutability = var.ecr_image_tag_mutability
  scan_on_push         = var.ecr_scan_on_push
  keep_last_images     = var.ecr_keep_last_images
  tags                 = local.common_tags
}
