variable "subnet_ids" {
  description = "The subnet IDs for the ALB."
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC ID."
  type        = string
}

variable "cert_arn" {
  description = "The ARN of the ACM certificate to use for HTTPS."
  type        = string
}
