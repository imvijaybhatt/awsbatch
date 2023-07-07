provider "aws" {
  region = "ap-northeast-1"
  // access_key = "my-access-key"
  // secret_key = "my-secret-key"
}

terraform {
  required_providers {
    aws = {
      version = ">= 5.4.0"
      source  = "hashicorp/aws"
    }
  }
}
