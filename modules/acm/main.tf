# Provider for us-east-1, required for CloudFront
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

# Provider for eu-central-1, required for ALB
provider "aws" {
  alias  = "eu-central-1"
  region = "eu-central-1"
}

# ACM Certificate for CloudFront in us-east-1
resource "aws_acm_certificate" "cloudfront" {
  provider          = aws.us-east-1
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "CloudFrontCertificate"
  }
}

resource "aws_route53_record" "cloudfront_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cloudfront.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = var.route53_zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "cloudfront" {
  provider                = aws.us-east-1
  certificate_arn         = aws_acm_certificate.cloudfront.arn
  validation_record_fqdns = [for record in aws_route53_record.cloudfront_validation : record.fqdn]
}

# ACM Certificate for ALB in eu-central-1
resource "aws_acm_certificate" "alb" {
  provider          = aws.eu-central-1
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "ALBCertificate"
  }
}

resource "aws_route53_record" "alb_validation" {
  for_each = {
    for dvo in aws_acm_certificate.alb.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = var.route53_zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "alb" {
  provider                = aws.eu-central-1
  certificate_arn         = aws_acm_certificate.alb.arn
  validation_record_fqdns = [for record in aws_route53_record.alb_validation : record.fqdn]
}
