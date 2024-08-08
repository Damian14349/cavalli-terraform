variable "ami_id" {
  description = "The AMI ID for EC2 instances."
  type        = string
}

variable "subnet_ids" {
  description = "The subnet IDs for the ASG."
  type        = list(string)
}
