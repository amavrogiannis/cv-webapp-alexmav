module "cvalexmav_web" {
  source = "../../modules/web"

  bucket_name = "cv.alexmav.co.uk"

  enable_website            = true
  enable_staging_cloudfront = true
  staging_cloudfront_id     = "E1AGIL3B6UY55K"

  # Tags
  service_group = "CV_Website"
  environment   = "Production"

  providers = {
    aws.virginia = aws.virginia
  }
}