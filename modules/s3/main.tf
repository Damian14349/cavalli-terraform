resource "aws_s3_bucket" "wordpress_content" {
  bucket = "${var.domain_name}-content"

  tags = {
    Name = "WordPressContent"
  }
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
