# Gatus config will be stored in SSM Parameter Store.
# Resource definition will be added after module scaffolding is in place.

resource "aws_ssm_parameter" "gatus_config" {
  name        = var.ssm_config_parameter_name
  description = "Gatus configuration file"
  type        = "String"
  value       = file("${path.module}/config/config.yaml")

  tags = {
    Name = "${local.name_prefix}-gatus-config"
  }
}
