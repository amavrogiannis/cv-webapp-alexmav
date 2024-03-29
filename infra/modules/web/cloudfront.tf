data "aws_acm_certificate" "this" {
  domain = var.domain_acm
}

resource "aws_cloudfront_origin_access_identity" "this" {
  comment  = var.comments
}

resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }
  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.comments
  default_root_object = "index.html"

  aliases = [var.bucket_name]


  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 1800
    max_ttl                = 3600
  }
  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/content/immutable/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 600
    max_ttl                = 3600
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }
  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/content/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 7200
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }
  price_class = "PriceClass_100"
  restrictions {
    geo_restriction {
      restriction_type = "blacklist"
      locations = [
        "RU", "KP", "SO", "AF", "BY", "BA", "BI", "CD", "GN", "GW", "HT", "IR", "SD", "SS", "LB", "LY", "YE", "VE", "NI"
      ]
    }
  }
  tags = local.tags

  #First, create certificate, before pasting the ARN here. 
  viewer_certificate {
    acm_certificate_arn            = data.aws_acm_certificate.this.arn
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.this.domain_name
}