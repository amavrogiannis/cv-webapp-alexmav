#############################################################
############## SETUP VARIABLES ##############################
#############################################################

### Legacy for Tags ###
variable "environment" {
  description = "Define the environment"
  type        = string
}

variable "service_group" {
  description = "Define the resource_group tag"
  type        = string
}

### General comments for all ###
variable "comments" {
  type    = string
  default = "Managed Terraform Resource"
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

variable "enable_staging_cloudfront" {
  description = "Confirm this is CloudFront staging env. True or False"
  type        = bool

}

variable "staging_cloudfront_id" {
  description = "Paste the CloudFront ID to utlise it for the Continuous Policy"
  type        = string
  default     = null
}