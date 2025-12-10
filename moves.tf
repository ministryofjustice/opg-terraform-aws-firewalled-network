moved {
  from = aws_subnet.public
  to   = aws_subnet.nat
}

moved {
  from = aws_route_table_association.public
  to   = aws_route_table_association.nat
}

moved {
  from = aws_route_table.public
  to   = aws_route_table.nat
}

moved {
  from = aws_route.public_internet_gateway
  to   = aws_route.nat_egress_via_internet_gateway
}

moved {
  from = aws_route.application_nat_gateway
  to   = aws_route.application_egress
}
