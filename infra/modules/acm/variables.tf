variable "name" {
  description = "Name prefix"
  type        = string
}

variable "domain_name" {
  description = "Root domain name"
  type        = string
}

variable "app_fqdn" {
  description = "Application FQDN"
  type        = string
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID"
  type        = string
}
