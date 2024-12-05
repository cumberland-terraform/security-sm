terraform {
  required_version          = ">= 1.5.0"

  required_providers {
    aws                     = {
      source                = "hashicorp/aws"
      version               = ">= 4.8.0"
    }
    random                  = {
      source                = "hashicorp/random"
      version               = "3.6.2"
    }
  }
}