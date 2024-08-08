output "bucket_id" {
  description = "The ID of the S3 bucket."
  value       = aws_s3_bucket.wordpress_content.id
}

output "oai_id" {
  description = "The ID of the CloudFront Origin Access Identity."
  value       = aws_cloudfront_origin_access_identity.oai.id
}
