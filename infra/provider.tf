terraform {
  required_version = ">= 1.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket         = "hk-gatus-tfstate-972598852792"
    key            = "ecs-fargate-platform/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "hk-gatus-tflock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = local.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}
