resource "aws_ecr_repository" "shipping_api" {
  name                 = "shipping-api"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}