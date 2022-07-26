terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.2.0"
    }
  }

  required_version = "1.1.6"
}

provider "aws" {
  region = "ap-southeast-1"
}