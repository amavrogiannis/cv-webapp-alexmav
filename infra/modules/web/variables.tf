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
