resource "aws_cloudfront_distribution" "wordpress" {
  origin {
    domain_name = "${var.s3_bucket}.s3.amazonaws.com"
    origin_id   = "S3-${var.s3_bucket}"

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/${var.oai_id}"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = [var.domain_name]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${var.s3_bucket}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  viewer_certificate {
    acm_certificate_arn            = var.cert_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2019"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "WordPressCloudFront"
  }
}
