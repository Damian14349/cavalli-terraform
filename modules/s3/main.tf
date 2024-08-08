resource "aws_s3_bucket" "wordpress_content" {
  bucket = "${var.domain_name}-content"

  tags = {
    Name = "WordPressContent"
  }
}

resource "aws_s3_bucket_acl" "wordpress_content_acl" {
  bucket = aws_s3_bucket.wordpress_content.id
  acl    = "private"
}

resource "aws_s3_bucket_website_configuration" "wordpress_content" {
  bucket = aws_s3_bucket.wordpress_content.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.wordpress_content.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for S3 access"
}

resource "aws_s3_bucket_policy" "allow_cloudfront_access" {
  bucket = aws_s3_bucket.wordpress_content.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "s3:GetObject"
        Effect    = "Allow"
        Resource  = "${aws_s3_bucket.wordpress_content.arn}/*"
        Principal = {
          AWS = "${aws_cloudfront_origin_access_identity.oai.iam_arn}"
        }
      },
    ]
  })
}
