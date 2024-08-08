variable "ami_id" {
  description = "The AMI ID for EC2 instances."
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID where the instance will be created."
  type        = string
}
