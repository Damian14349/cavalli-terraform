resource "aws_cognito_user_pool" "user_pool" {
  name = "events-user-pool"
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  user_pool_id = aws_cognito_user_pool.user_pool.id
  name         = "events-user-pool-client"
  generate_secret = false
}
