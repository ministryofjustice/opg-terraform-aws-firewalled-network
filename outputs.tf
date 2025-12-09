output "application_subnets" {
  value = aws_subnet.application
}

output "application_subnet_route_tables" {
  value = aws_route_table.application
}

output "data_subnets" {
  value = aws_subnet.data
}

output "flow_log_cloudwatch_log_group" {
  value = aws_cloudwatch_log_group.flow_log
}

output "public_subnets" {
  value = aws_subnet.alb
}

output "public_subnet_route_tables" {
  value = aws_route_table.alb
}

output "vpc" {
  value = aws_vpc.main
}
