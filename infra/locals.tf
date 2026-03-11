locals {
  project_name = var.project_name
  name_prefix  = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = local.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  app_fqdn = "${var.subdomain}.${var.domain_name}"
}
