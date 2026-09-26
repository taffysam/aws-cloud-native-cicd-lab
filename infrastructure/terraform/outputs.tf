output "ecr_repository_url" {
  description = "URL of the shipping API ECR repository"
  value       = aws_ecr_repository.shipping_api.repository_url
}