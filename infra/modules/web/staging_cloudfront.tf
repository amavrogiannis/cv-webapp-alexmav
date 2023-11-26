// STAGING CLOUDFRONT RESOURCE

resource "aws_cloudfront_origin_access_identity" "this_staging" {
  comment = var.comments
}

resource "aws_cloudfront_distribution" "this_staging" {
  enabled = var.enable_staging_cloudfront
  staging = var.enable_staging_cloudfront

  origin {
    domain_name = aws_s3_bucket.this_staging.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this_staging.cloudfront_access_identity_path
    }
  }
  is_ipv6_enabled     = true
  comment             = var.comments
  default_root_object = "index.html"

  aliases = [var.staging_domain]


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
    max_ttl                = 86400
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
  tags   = merge(
    local.tags,
    {
      Environment = "${var.environment_test}"
    }
  )

  #First, create certificate, before pasting the ARN here. 
  viewer_certificate {
    acm_certificate_arn            = data.aws_acm_certificate.this.arn
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }
}

output "staging_domain_name" {
  value = aws_cloudfront_distribution.this_staging.domain_name
}

// Continuous Deployment Policy
resource "aws_cloudfront_continuous_deployment_policy" "cdn_policy" {
  enabled = var.enable_staging_cloudfront

  staging_distribution_dns_names {
    items    = [aws_cloudfront_distribution.this_staging.domain_name]
    quantity = 1
  }

  traffic_config {
    type = "SingleWeight"
    single_weight_config {
      weight = "0.01"
    }
  }
}