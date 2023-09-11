terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.5.0"
    }
  }
}

data "aws_availability_zones" "all" {
  state = "available"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}
