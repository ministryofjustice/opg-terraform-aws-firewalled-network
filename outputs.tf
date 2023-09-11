output "public_subnets" {
  value = aws_subnet.public
}

output "application_subnets" {
  value = aws_subnet.application
}

output "data_subnets" {
  value = aws_subnet.data
}

output "vpc" {
  value = aws_vpc.main
}
