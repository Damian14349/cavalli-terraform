output "zone_id" {
  description = "The ID of the Route 53 hosted zone."
  value       = var.zone_id
}

output "name_servers" {
  description = "The name servers for the Route 53 hosted zone."
  value       = aws_route53_zone.primary.name_servers
}