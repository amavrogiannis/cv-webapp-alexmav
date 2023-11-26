#############################################################
############## SETUP VARIABLES ##############################
#############################################################

### Legacy for Tags ###
variable "environment" {
  description = "Define the environment"
  type        = string
}

variable "environment_test" {
  description = "Define test env"
  type = string
  default = null
  
}

### General comments for all ###
variable "comments" {
  type    = string
  default = "Managed Terraform Resource"
}

// Fetch certificate data - domain name required
variable "primary_domain_certificate" {
  description = "Need to enter the domain name, which the CloudFront will inherit the certificate from."
  type = string
  default = null
}


### Bucket ###
variable "bucket_name" {
  description = "Give a name on the bucket"
  type        = string
}

variable "enable_website" {
  description = "Define the resource_group tag"
  type        = bool
}

// Staging config
variable "staging_domain" {
  description = "Give a name on staging bucket"
  type        = string
}
variable "enable_staging_cloudfront" {
  description = "Confirm this is CloudFront staging env. True or False"
  type        = bool
  default = false
}
