variable "s3_bucket" {
  description = "The S3 bucket domain name."
  type        = string
}

variable "cert_arn" {
  description = "The ARN of the ACM certificate."
  type        = string
}

variable "domain_name" {
  description = "The domain name for the CloudFront distribution."
  type        = string
}

variable "oai_id" {
  description = "The ID of the CloudFront Origin Access Identity."
  type        = string
}
