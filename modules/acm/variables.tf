variable "domain_name" {
  description = "The domain name to use for ACM certificates."
  type        = string
}

variable "route53_zone_id" {
  description = "The Route 53 zone ID where the DNS validation records will be created."
  type        = string
}
