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

variable "lambda_bucket" {
  description = "The S3 bucket where Lambda function code is stored."
  default     = "lambda-code-bucket"
}

variable "lambda_zip_key" {
  description = "The key in S3 bucket where Lambda code zip file is stored."
  default     = "lambda.zip"
}

# Nowe zmienne dla nowych modułów (Lambda, DynamoDB, Cognito)

variable "dynamodb_table" {
  description = "The name of the DynamoDB table."
  default     = "events"
}

variable "lambda_function_name" {
  description = "The name of the Lambda function."
  default     = "backend-function"
}

variable "lambda_runtime" {
  description = "The runtime for the Lambda function (e.g., nodejs14.x)."
  default     = "nodejs14.x"
}

variable "cognito_user_pool_name" {
  description = "The name of the Cognito User Pool."
  default     = "events-user-pool"
}

variable "cognito_user_pool_client_name" {
  description = "The name of the Cognito User Pool Client."
  default     = "events-user-pool-client"
}
