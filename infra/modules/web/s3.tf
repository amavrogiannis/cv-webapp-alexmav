#############################################################
############## S3 Bucket Config #############################
#############################################################

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  tags   = merge(
    local.tags,
    {
      Environment   = "${var.environment}"
    }
  )
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = true
  restrict_public_buckets = true
}

# Website config within the bucket config.
resource "aws_s3_bucket_website_configuration" "this" {
  count = var.enable_website ? 1 : 0

  bucket = aws_s3_bucket.this.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

# Get bucket policy
resource "aws_s3_bucket_policy" "this" {
  count = var.enable_website ? 1 : 0

  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this_policy.json

  depends_on = [data.aws_iam_policy_document.this_policy]
}

data "aws_iam_policy_document" "this_policy" {
  statement {
    sid = "PublicReadGetObject"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${aws_s3_bucket.this.arn}/*",
    ]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.this.iam_arn]
    }
  }

  depends_on = [
    aws_cloudfront_origin_access_identity.this
  ]
}
