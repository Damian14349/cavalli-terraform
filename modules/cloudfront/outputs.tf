output "oai_arn" {
  description = "The ARN of the CloudFront Origin Access Identity."
  value       = aws_cloudfront_origin_access_identity.oai.iam_arn
}

output "cf_domain_name" {
  description = "The domain name of the CloudFront distribution."
  value       = aws_cloudfront_distribution.wordpress.domain_name
}
