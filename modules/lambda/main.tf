resource "aws_lambda_function" "lambda_function" {
  function_name = "backend-function"
  role          = var.iam_role_arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  s3_bucket     = var.bucket
  s3_key        = var.zip_key

  environment {
    variables = {
      DYNAMODB_TABLE = var.dynamodb_table  # Używamy przekazanej zmiennej dynamodb_table
    }
  }
}
