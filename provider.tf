provider "aws" {
  region = "eu-west-3"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }

  backend "s3" {
    bucket = "boutheyna-actions"
    key    = "Test.tfstate"
    encrypt = true
    region = "eu-west-3"
  }
}
