resource "aws_ecr_repository" "private" {
  name                 = var.repository_name
  image_tag_mutability = var.repository_image_tag_mutability

  force_delete = var.repository_force_delete

  image_scanning_configuration {
    scan_on_push = var.repository_image_scan_on_push
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "main" {
  repository = aws_ecr_repository.private.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowAccessForAuthorizedUsers"
        Effect = "Allow"
        Principal = {
          AWS = var.repository_read_write_access_arns
        }
        Action = [
          "ecr:*"
        ]
      }
    ]
  })
}
