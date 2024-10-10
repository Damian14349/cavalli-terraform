variable "bucket" {
  description = "The S3 bucket where Lambda function code is stored."
}

variable "zip_key" {
  description = "The S3 key for the Lambda code zip file."
}

variable "iam_role_arn" {
  description = "The ARN of the IAM role for Lambda function."
}

variable "dynamodb_table" {
  description = "The name of the DynamoDB table."
  type        = string
}
