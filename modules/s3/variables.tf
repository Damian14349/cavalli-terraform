variable "domain_name" {
  description = "The domain name to use for the S3 bucket."
  type        = string
}

variable "cloudfront_oai_arn" {
  description = "The ARN of the CloudFront Origin Access Identity"
  type        = string
}