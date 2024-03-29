module "cvalexmav_web" {
  source = "../../modules/web"

  bucket_name = "cv.alexmav.co.uk"
  enable_website = true
  domain_acm = "cv.alexmav.co.uk"

  # Tags
  service_group = "CV_Website"
  environment   = "Production"

  providers = {
    aws.virginia = aws.virginia
  }
}
