resource "aws_networkfirewall_vpc_endpoint_association" "shared" {
  count        = local.use_shared_firewall ? 3 : 0
  firewall_arn = "arn:aws:network-firewall:${data.aws_region.current.region}:${var.shared_firewall_configuration.account_id}:firewall/shared-network-firewall-${var.shared_firewall_configuration.account_name}-${data.aws_availability_zones.all.names[count.index]}"
  vpc_id       = aws_vpc.main.id

  subnet_mapping {
    subnet_id = aws_subnet.firewall[count.index].id
  }
}
