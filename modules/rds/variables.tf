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
}

variable "vpc_security_group_ids" {
  description = "List of VPC Security Group IDs for the RDS instance."
  type        = list(string)
}

variable "db_subnet_group_name" {
  description = "The name of the DB Subnet Group to associate with the RDS instance."
}
