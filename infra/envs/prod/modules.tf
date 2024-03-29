module "cvalexmav_web" {
  source = "../../modules/web"

  bucket_name = "cv.alexmav.co.uk"

  enable_website = true

  # Tags
  service_group = "CV_Website"
  environment   = "Production"

}