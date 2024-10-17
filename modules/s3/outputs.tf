output "bucket_id" {
  description = "The ID of the S3 bucket."
  value       = aws_s3_bucket.wordpress_content.id
}

output "bucket_domain_name" {
  description = "The domain name of the S3 bucket."
  value       = aws_s3_bucket.wordpress_content.bucket_regional_domain_name
}