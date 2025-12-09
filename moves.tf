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
