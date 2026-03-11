variable "name" {
  description = "Name prefix"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "ECS security group ID"
  type        = string
}

variable "target_group_arn" {
  description = "ALB target group ARN"
  type        = string
}

variable "https_listener_arn" {
  description = "HTTPS listener ARN"
  type        = string
}

variable "execution_role_arn" {
  description = "ECS task execution role ARN"
  type        = string
}

variable "ecr_repository_url" {
  description = "ECR repository URL"
  type        = string
}

variable "image_tag" {
  description = "Image tag to deploy"
  type        = string
}

variable "container_port" {
  description = "Container port"
  type        = number
}

variable "container_cpu" {
  description = "Fargate CPU"
  type        = number
}

variable "container_memory" {
  description = "Fargate memory"
  type        = number
}

variable "desired_count" {
  description = "Desired service count"
  type        = number
}

variable "ssm_parameter_name" {
  description = "SSM parameter name for Gatus config"
  type        = string
}

variable "ssm_parameter_arn" {
  description = "SSM parameter ARN for Gatus config"
  type        = string
}
