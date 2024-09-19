resource "aws_lambda_function" "lambda_function" {
  function_name = "backend-function"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  s3_bucket     = var.bucket
  s3_key        = var.zip_key

  environment {
    variables = {
      DYNAMODB_TABLE = module.dynamodb.table_name
    }
  }
}
