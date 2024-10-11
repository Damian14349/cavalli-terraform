variable "bucket" {
  description = "The S3 bucket where Lambda function code is stored."
  default     = "devopser.pl-content"
}

variable "zip_key" {
  description = "The S3 key for the Lambda code zip file."
  default     = "lambda.zip"
}

variable "iam_role_arn" {
  description = "The ARN of the IAM role for Lambda function."
  default     = "arn:aws:iam::590183938768:role/lambda_exec_role"
}

variable "dynamodb_table" {
  description = "The name of the DynamoDB table."
  type        = string
  default     = "events"
}
