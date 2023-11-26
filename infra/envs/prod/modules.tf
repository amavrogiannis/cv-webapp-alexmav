module "cvalexmav_web" {
  source = "../../modules/web"

  primary_domain_certificate = "alexmav.co.uk"

  // Staging website
  bucket_name = "cv.alexmav.co.uk"
  enable_website            = true
  # Tags
  environment   = "Production"

  // Staging webstie
  enable_staging_cloudfront = true
  staging_domain = "test.alexmav.co.uk"
  // Tags
  environment_test = "Development"

  providers = {
    aws.virginia = aws.virginia
  }
}