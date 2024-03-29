module "testalexmav_web" {
  source = "../../modules/web"

  bucket_name = "test.alexmav.co.uk"

  enable_website = true

  # Tags
  service_group = "Test_Website"
  environment   = "Development"

}