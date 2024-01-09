data "aws_availability_zones" "all" {
  state = "available"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}
