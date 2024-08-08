variable "region" {
  description = "The AWS region to deploy to."
  default     = "eu-central-1"
}

variable "domain_name" {
  description = "The domain name to use."
  default     = "cavalli.com.pl"
}

variable "ami_id" {
  description = "The AMI ID for EC2 instances."
  default     = "ami-083c806d346039a38"
}
