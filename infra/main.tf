# Root module orchestration file.
# Child modules will be added step by step:
# - vpc
# - security-groups
# - ecr
# - iam
# - acm
# - alb
# - route53
# - ecs

module "vpc" {
  source = "./modules/vpc"

  name                 = local.name_prefix
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.availability_zones
}

module "security_groups" {
  source = "./modules/security-groups"

  name           = local.name_prefix
  vpc_id         = module.vpc.vpc_id
  container_port = var.container_port
}

module "ecr" {
  source = "./modules/ecr"

  repository_name = "${local.name_prefix}-gatus"
}

module "iam" {
  source = "./modules/iam"

  name               = local.name_prefix
  github_repo        = var.github_repo
  ecr_repository_arn = module.ecr.repository_arn
  ssm_parameter_arn  = aws_ssm_parameter.gatus_config.arn
}

module "acm" {
  source = "./modules/acm"

  name           = local.name_prefix
  domain_name    = var.domain_name
  app_fqdn       = local.app_fqdn
  hosted_zone_id = data.aws_route53_zone.primary.zone_id
}

module "alb" {
  source = "./modules/alb"

  name                  = local.name_prefix
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.security_groups.alb_security_group_id
  container_port        = var.container_port
  certificate_arn       = module.acm.certificate_arn
}

module "route53" {
  source = "./modules/route53"

  hosted_zone_id = data.aws_route53_zone.primary.zone_id
  app_fqdn       = local.app_fqdn
  alb_dns_name   = module.alb.alb_dns_name
  alb_zone_id    = module.alb.alb_zone_id
}

module "ecs" {
  source = "./modules/ecs"

  name                  = local.name_prefix
  aws_region            = var.aws_region
  private_subnet_ids    = module.vpc.private_subnet_ids
  ecs_security_group_id = module.security_groups.ecs_security_group_id
  target_group_arn      = module.alb.target_group_arn
  https_listener_arn    = module.alb.https_listener_arn
  execution_role_arn    = module.iam.ecs_task_execution_role_arn
  ecr_repository_url    = module.ecr.repository_url
  image_tag             = var.gatus_image_tag
  container_port        = var.container_port
  container_cpu         = var.container_cpu
  container_memory      = var.container_memory
  desired_count         = var.desired_count
  ssm_parameter_name    = var.ssm_config_parameter_name
  ssm_parameter_arn     = aws_ssm_parameter.gatus_config.arn
}
