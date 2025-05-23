output "repository_name" {
  description = "Name of the repository"
  value       = aws_ecr_repository.private.name
}

output "repository_arn" {
  description = "Full ARN of the repository"
  value       = aws_ecr_repository.private.arn
}

output "repository_url" {
  description = "The URL of the repository"
  value       = aws_ecr_repository.private.repository_url
}

