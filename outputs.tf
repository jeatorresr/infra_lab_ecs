output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "repository_name" {
  description = "Name of the repository"
  value       = module.ecr.repository_name
}

output "repository_arn" {
  description = "Full ARN of the repository"
  value       = module.ecr.repository_arn
}

output "repository_url" {
  description = "The URL of the repository"
  value       = module.ecr.repository_url
}
