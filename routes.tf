// ALB Subnet Routes
resource "aws_route" "alb_egress_via_internet_gateway" {
  count                  = 3
  route_table_id         = aws_route_table.alb[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id

  timeouts {
    create = "5m"
  }
}

// Nat Routes
resource "aws_route" "nat_egress_via_internet_gateway" {
  count                  = 3
  route_table_id         = aws_route_table.nat[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "nat_to_application_via_firewall" {
  count                  = var.network_firewall_enabled ? 3 : 0
  route_table_id         = aws_route_table.nat[count.index].id
  destination_cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 7, count.index + local.subnet_cidr_block_netnum.application)
  vpc_endpoint_id        = local.use_shared_firewall ? tolist(aws_networkfirewall_vpc_endpoint_association.shared[count.index].vpc_endpoint_association_status[0].association_sync_state)[0].attachment[0].endpoint_id : tolist(aws_networkfirewall_firewall.main[count.index].firewall_status[0].sync_states)[0].attachment[0].endpoint_id

  timeouts {
    create = "5m"
  }
}

// Firewall Subnet Routes
resource "aws_route" "firewall_nat_gateway" {
  count                  = 3
  route_table_id         = aws_route_table.firewall[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.gw[count.index].id
  timeouts {
    create = "5m"
  }
}

// Application Subnet Routes
resource "aws_route" "application_egress" {
  count                  = 3
  route_table_id         = aws_route_table.application[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.network_firewall_enabled ? null : aws_nat_gateway.gw[count.index].id
  vpc_endpoint_id        = var.network_firewall_enabled ? local.use_shared_firewall ? tolist(aws_networkfirewall_vpc_endpoint_association.shared[count.index].vpc_endpoint_association_status[0].association_sync_state)[0].attachment[0].endpoint_id : tolist(aws_networkfirewall_firewall.main[count.index].firewall_status[0].sync_states)[0].attachment[0].endpoint_id : null
  timeouts {
    create = "5m"
  }
}
