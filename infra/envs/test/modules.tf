# module "testalexmav_web" {
#   source = "../../modules/web"

#   bucket_name = "test.alexmav.co.uk"

#   enable_website = true

#   enable_staging_cloudfront = false
#   staging_cloudfront_id = null

#   # Tags
#   service_group = "Test_Website"
#   environment   = "Development"

#   providers = {
#     aws.virginia = aws.virginia
#   }
# }