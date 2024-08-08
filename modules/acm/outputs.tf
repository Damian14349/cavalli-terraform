output "cert_arn_us_east_1" {
  value = aws_acm_certificate.cloudfront.arn
}

output "cert_arn_eu_central_1" {
  value = aws_acm_certificate.alb.arn
}
