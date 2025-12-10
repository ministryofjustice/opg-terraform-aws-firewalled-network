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

output "lb_subnets" {
  value = aws_subnet.lb
}

output "lb_subnet_route_tables" {
  value = aws_route_table.lb
}

output "public_subnets" {
  value = aws_subnet.lb
}

output "public_subnet_route_tables" {
  value = aws_route_table.lb
}

output "vpc" {
  value = aws_vpc.main
}
