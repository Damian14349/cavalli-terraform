variable "domain_name" {
  description = "The domain name to use for Route 53."
  type        = string
}

variable "cf_domain_name" {
  description = "The domain name of the CloudFront distribution."
  type        = string
}

variable "zone_id" {
  description = "The ID of the existing Route 53 hosted zone."
  type        = string
}
