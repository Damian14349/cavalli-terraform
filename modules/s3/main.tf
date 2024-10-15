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

resource "aws_s3_bucket_policy" "wordpress_content_policy" {
  bucket = aws_s3_bucket.wordpress_content.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::590183938768:user/Damian"
      },
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.wordpress_content.id}",
        "arn:aws:s3:::${aws_s3_bucket.wordpress_content.id}/*"
      ]
    }
  ]
}
EOF
}
