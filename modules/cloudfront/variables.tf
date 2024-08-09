variable "alb_origin_dns" {
  description = "The DNS name of the ALB to be used as the CloudFront origin."
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
