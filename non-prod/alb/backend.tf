terraform {
  required_version = ">= 1.0.5"
  
  backend "s3" {
    region         = "ap-southeast-1"
    bucket         = "infra-nonprod-tf-state-lock"
    key            = "alb/terraform.tfstate"
    encrypt        = "true"
  }
}
