#############################################################
############## S3 Bucket Config #############################
#############################################################

locals {
  tags = {
    Service_Group = "CV_Website"
  }
  s3_origin_id = "Application"
}

resource "aws_s3_bucket" "this_staging" {
  bucket = var.staging_domain
  tags   = merge(
    local.tags,
    {
      Environment = "${var.environment_test}"
    }
  )
}

resource "aws_s3_bucket_ownership_controls" "this_staging" {
  bucket = aws_s3_bucket.this_staging.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this_staging" {
  bucket = aws_s3_bucket.this_staging.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this_staging" {
  bucket = aws_s3_bucket.this_staging.id

  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = true
  restrict_public_buckets = true
}

# Website config within the bucket config.
resource "aws_s3_bucket_website_configuration" "this_staging" {
  count = var.enable_staging_cloudfront ? 1 : 0

  bucket = aws_s3_bucket.this_staging.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

# Get bucket policy
resource "aws_s3_bucket_policy" "this_staging" {
  count = var.enable_staging_cloudfront ? 1 : 0

  bucket = aws_s3_bucket.this_staging.id
  policy = data.aws_iam_policy_document.this_staging_policy.json

  depends_on = [data.aws_iam_policy_document.this_staging_policy]
}

data "aws_iam_policy_document" "this_staging_policy" {
  statement {
    sid = "PublicReadGetObject"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${aws_s3_bucket.this_staging.arn}/*",
    ]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.this_staging.iam_arn]
    }
  }

  depends_on = [
    aws_cloudfront_origin_access_identity.this_staging
  ]
}
