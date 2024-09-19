output "alb_security_group_id" {
  description = "The ID of the security group used by ALB."
  value       = local.use_existing_sg ? data.aws_security_group.existing_sg[0].id : aws_security_group.alb_sg[0].id
}

output "alb_dns_name" {
  description = "The DNS name of the ALB."
  value       = module.alb.dns_name
}

output "cloudfront_domain_name" {
  description = "The domain name of the CloudFront distribution."
  value       = module.cloudfront.cf_domain_name
}

output "lambda_function_name" {
  description = "The name of the Lambda function."
  value       = aws_lambda_function.backend.function_name
}

output "api_gateway_url" {
  description = "The URL of the API Gateway."
  value       = aws_api_gateway_rest_api.api.execution_arn
}

output "dynamodb_table_name" {
  description = "The name of the DynamoDB table."
  value       = aws_dynamodb_table.events.name
}

output "cognito_user_pool_id" {
  description = "The ID of the Cognito user pool."
  value       = aws_cognito_user_pool.user_pool.id
}