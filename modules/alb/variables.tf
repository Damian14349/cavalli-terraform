variable "vpc_id" {
  description = "The VPC ID where the ALB will be deployed."
  type        = string
}

variable "subnet_ids" {
  description = "The subnets where the ALB will be deployed."
  type        = list(string)
}

variable "cert_arn" {
  description = "The ARN of the ACM certificate for HTTPS."
  type        = string
}

variable "sg_id" {
  description = "The ID of the security group for ALB."
  type        = string
}
