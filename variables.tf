variable "region" {
  description = "The AWS region to deploy to."
  default     = "eu-central-1"
}

variable "domain_name" {
  description = "The domain name to use."
  default     = "devopser.pl"
}

variable "ami_id" {
  description = "The AMI ID for EC2 instances."
  default     = "ami-0cdce8cdcb7995d0b"
}

variable "use_existing_sg" {
  description = "Set to true if you want to use an existing security group."
  type        = bool
  default     = false
}

variable "existing_sg_name" {
  description = "The name of the existing security group to use."
  default     = "allow_http_https"
}

variable "db_instance_class" {
  description = "Class of the RDS instance"
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "The name of the database"
  default     = "wordpress"
}

variable "db_user" {
  description = "Database username"
  default     = "admin"
}

variable "db_password" {
  description = "The password for the database"
  default     = "password"
}