variable "name" {
  description = "Name prefix for IAM resources"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository in owner/repo format"
  type        = string
}

variable "ecr_repository_arn" {
  description = "ECR repository ARN"
  type        = string
}

variable "ssm_parameter_arn" {
  description = "SSM parameter ARN for Gatus config"
  type        = string
}
