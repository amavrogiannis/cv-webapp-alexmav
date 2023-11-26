#############################################################
############## SET THE FOLLOWING ENV VARIABLES ##############
############## 1. TF_VAR_PROFILE ############################
############## 2. TF_VAR_REGION  ############################
#############################################################

# Config for main resources
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
      # configuration_aliases = [ aws.main, aws.virginia ]
    }
  }

  # required_version = ">= 1.2"
}

terraform {
  backend "s3" {}
}

provider "aws" {
  # alias = "main"
  region  = "eu-west-1"
  # profile = var.PROFILE
  default_tags {
    tags = {
      Terraform    = "TRUE"
    }
  }
}

provider "aws" {
  alias = "virginia"
  region  = "us-east-1"
  # profile = var.PROFILE_US
}