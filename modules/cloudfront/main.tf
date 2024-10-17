resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for S3 access"
}

resource "aws_cloudfront_cache_policy" "default" {
  name    = "DefaultCachePolicy"
  comment = "Default Cache Policy"

  default_ttl = 0
  max_ttl     = 0
  min_ttl     = 0

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "none"
    }
  }
}

resource "aws_cloudfront_cache_policy" "optimized" {
  name    = "OptimizedCachePolicy"
  comment = "Optimized Cache Policy with Caching Enabled"

  default_ttl = 86400 # 1 day
  max_ttl     = 31536000 # 1 year
  min_ttl     = 0

  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_gzip = true
    enable_accept_encoding_brotli = true
    cookies_config {
      cookie_behavior = "all"
    }
    headers_config {
      header_behavior = "whitelist"
      headers {
        items = ["Host"]
      }
    }
    query_strings_config {
      query_string_behavior = "all"
    }
  }
}

resource "aws_cloudfront_origin_request_policy" "default" {
  name    = "DefaultOriginRequestPolicy"
  comment = "Default Origin Request Policy"

  cookies_config {
    cookie_behavior = "none"
  }

  headers_config {
    header_behavior = "none"
  }

  query_strings_config {
    query_string_behavior = "none"
  }
}

resource "aws_cloudfront_origin_request_policy" "all_viewer" {
  name    = "AllViewerRequestPolicy"
  comment = "Origin Request Policy forwarding all headers, cookies, and query strings"

  cookies_config {
    cookie_behavior = "all"
  }

  headers_config {
    header_behavior = "allViewer"
  }

  query_strings_config {
    query_string_behavior = "all"
  }
}

resource "aws_cloudfront_origin_request_policy" "s3_custom" {
  name    = "S3CustomOriginRequestPolicy"
  comment = "Forward specific headers to S3 for /wp-content/uploads/*"

  headers_config {
    header_behavior = "whitelist"
    headers {
      items = ["Origin", "Access-Control-Request-Headers", "Access-Control-Request-Method"]
    }
  }

  cookies_config {
    cookie_behavior = "none"
  }

  query_strings_config {
    query_string_behavior = "none"
  }
}

resource "aws_cloudfront_distribution" "wordpress" {
  origin {
    domain_name = var.alb_origin_dns
    origin_id   = "ALB-WordPress"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  origin {
    domain_name = var.s3_bucket_domain_name
    origin_id   = "S3-WordPressContent"
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true

  aliases = [var.domain_name]

  default_cache_behavior {
    target_origin_id = "ALB-WordPress"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]

    cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    origin_request_policy_id = "33f36d7e-f396-46d9-90e0-52428a34d9dc"
  }

  ordered_cache_behavior {
    path_pattern     = "/wp-content/*"
    target_origin_id = "ALB-WordPress"

    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]

    cache_policy_id           = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    origin_request_policy_id   = "33f36d7e-f396-46d9-90e0-52428a34d9dc"
  }

  ordered_cache_behavior {
    path_pattern           = "wp-content/uploads/*"
    target_origin_id       = "S3-WordPressContent"
    viewer_protocol_policy = "redirect-to-https"
    
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]

    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    origin_request_policy_id = aws_cloudfront_origin_request_policy.s3_custom.id
  }

  viewer_certificate {
    acm_certificate_arn      = var.cert_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
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
