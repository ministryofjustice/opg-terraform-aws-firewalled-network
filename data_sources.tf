data "aws_availability_zones" "all" {
  state = "available"
}

data "aws_caller_identity" "main" {}

data "aws_default_tags" "default_tags" {}

data "aws_region" "current" {}
