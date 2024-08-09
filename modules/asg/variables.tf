variable "ami_id" {
  description = "The AMI ID for the launch configuration."
  type        = string
}

variable "subnet_ids" {
  description = "The subnet IDs where the instances will be launched."
  type        = list(string)
}

variable "sg_id" {
  description = "The security group ID for the instances."
  type        = string
}
