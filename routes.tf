// Public Subnet Routes
resource "aws_route" "public_internet_gateway" {
  count                  = 3
  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route" "public_to_application_via_firewall_0" {
  count                  = var.network_firewall_enabled ? 3 : 0
  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = aws_subnet.application[0].cidr_block
  vpc_endpoint_id        = var.use_shared_firewall ? tolist(aws_networkfirewall_vpc_endpoint_association.shared[count.index].vpc_endpoint_association_status[0].association_sync_state)[0].attachment[0].endpoint_id : tolist(aws_networkfirewall_firewall.main[count.index].firewall_status[0].sync_states)[0].attachment[0].endpoint_id
}

resource "aws_route" "public_to_application_via_firewall_1" {
  count                  = var.network_firewall_enabled ? 3 : 0
  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = aws_subnet.application[1].cidr_block
  vpc_endpoint_id        = var.use_shared_firewall ? tolist(aws_networkfirewall_vpc_endpoint_association.shared[count.index].vpc_endpoint_association_status[0].association_sync_state)[0].attachment[0].endpoint_id : tolist(aws_networkfirewall_firewall.main[count.index].firewall_status[0].sync_states)[0].attachment[0].endpoint_id
}

resource "aws_route" "public_to_application_via_firewall_3" {
  count                  = var.network_firewall_enabled ? 3 : 0
  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = aws_subnet.application[2].cidr_block
  vpc_endpoint_id        = var.use_shared_firewall ? tolist(aws_networkfirewall_vpc_endpoint_association.shared[count.index].vpc_endpoint_association_status[0].association_sync_state)[0].attachment[0].endpoint_id : tolist(aws_networkfirewall_firewall.main[count.index].firewall_status[0].sync_states)[0].attachment[0].endpoint_id
}

// Firewall Subnet Routes
resource "aws_route" "firewall_nat_gateway" {
  count                  = 3
  route_table_id         = aws_route_table.firewall[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.gw[count.index].id
}

// Application Subnet Routes
resource "aws_route" "application_nat_gateway" {
  count                  = 3
  route_table_id         = aws_route_table.application[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.network_firewall_enabled ? null : aws_nat_gateway.gw[count.index].id
  vpc_endpoint_id        = var.network_firewall_enabled ? var.use_shared_firewall ? tolist(aws_networkfirewall_vpc_endpoint_association.shared[count.index].vpc_endpoint_association_status[0].association_sync_state)[0].attachment[0].endpoint_id : tolist(aws_networkfirewall_firewall.main[count.index].firewall_status[0].sync_states)[0].attachment[0].endpoint_id : null
}

resource "aws_route" "application_to_public_via_firewall_0" {
  count                  = var.network_firewall_enabled ? 3 : 0
  route_table_id         = aws_route_table.application[count.index].id
  destination_cidr_block = aws_subnet.public[0].cidr_block
  vpc_endpoint_id        = var.use_shared_firewall ? tolist(aws_networkfirewall_vpc_endpoint_association.shared[count.index].vpc_endpoint_association_status[0].association_sync_state)[0].attachment[0].endpoint_id : tolist(aws_networkfirewall_firewall.main[count.index].firewall_status[0].sync_states)[0].attachment[0].endpoint_id
}

resource "aws_route" "application_to_public_via_firewall_1" {
  count                  = var.network_firewall_enabled ? 3 : 0
  route_table_id         = aws_route_table.application[count.index].id
  destination_cidr_block = aws_subnet.public[1].cidr_block
  vpc_endpoint_id        = var.use_shared_firewall ? tolist(aws_networkfirewall_vpc_endpoint_association.shared[count.index].vpc_endpoint_association_status[0].association_sync_state)[0].attachment[0].endpoint_id : tolist(aws_networkfirewall_firewall.main[count.index].firewall_status[0].sync_states)[0].attachment[0].endpoint_id
}

resource "aws_route" "application_to_public_via_firewall_3" {
  count                  = var.network_firewall_enabled ? 3 : 0
  route_table_id         = aws_route_table.application[count.index].id
  destination_cidr_block = aws_subnet.public[2].cidr_block
  vpc_endpoint_id        = var.use_shared_firewall ? tolist(aws_networkfirewall_vpc_endpoint_association.shared[count.index].vpc_endpoint_association_status[0].association_sync_state)[0].attachment[0].endpoint_id : tolist(aws_networkfirewall_firewall.main[count.index].firewall_status[0].sync_states)[0].attachment[0].endpoint_id
}
