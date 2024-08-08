resource "aws_route53_record" "www" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.cf_domain_name
    zone_id                = "Z2FDTNDATAQYW2" # CloudFront Hosted Zone ID
    evaluate_target_health = false
  }
}

resource "aws_route53_zone" "primary" {
  name = var.domain_name
}
