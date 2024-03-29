module "testalexmav_web" {
  source = "../../modules/web"

  bucket_name = "test.alexmav.co.uk"

  enable_website = true
  
  domain_acm = "test.alexmav.co.uk"

  # Tags
  service_group = "Test_Website"
  environment   = "Development"

  providers = {
    aws.virginia = aws.virginia
  }
}