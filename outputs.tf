output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution."
  value       = module.cloudfront.cf_distribution_id
}

output "route53_name_servers" {
  description = "The name servers from Route 53."
  value       = module.route53.name_servers
}
