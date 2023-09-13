locals {
  subnet_cidr_block_netnum = {
    public      = 45
    firewall    = 65
    application = 95
    data        = 115
  }
}

// Public Subnets
resource "aws_subnet" "public" {
  count                           = 3
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = cidrsubnet(aws_vpc.main.cidr_block, 7, count.index + local.subnet_cidr_block_netnum.public)
  availability_zone               = data.aws_availability_zones.all.names[count.index]
  map_public_ip_on_launch         = var.map_public_ip_on_launch
  assign_ipv6_address_on_creation = var.public_subnet_assign_ipv6_address_on_creation
  tags                            = { Name = "public-${data.aws_availability_zones.all.names[count.index]}" }
}

resource "aws_route_table_association" "public" {
  count          = 3
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

resource "aws_route_table" "public" {
  count  = 3
  vpc_id = aws_vpc.main.id
  tags   = { Name = "public-route-table" }
}

resource "aws_route" "public_internet_gateway" {
  count                  = 3
  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id

  timeouts {
    create = "5m"
  }
}

// Firewall Subets
resource "aws_subnet" "firewall" {
  count                           = 3
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = cidrsubnet(aws_vpc.main.cidr_block, 7, count.index + local.subnet_cidr_block_netnum.firewall)
  availability_zone               = data.aws_availability_zones.all.names[count.index]
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = false
  tags                            = { Name = "firewall-${data.aws_availability_zones.all.names[count.index]}" }
}

resource "aws_route_table_association" "firewall" {
  count          = 3
  subnet_id      = aws_subnet.firewall[count.index].id
  route_table_id = aws_route_table.firewall[count.index].id
}

resource "aws_route_table" "firewall" {
  count  = 3
  vpc_id = aws_vpc.main.id
  tags   = { Name = "firewall-route-table" }
}

resource "aws_route" "firewall_nat_gateway" {
  count                  = 3
  route_table_id         = element(aws_route_table.firewall.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.gw.*.id, count.index)

  timeouts {
    create = "5m"
  }
}

// Application Subets
resource "aws_subnet" "application" {
  count                           = 3
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = cidrsubnet(aws_vpc.main.cidr_block, 7, count.index + local.subnet_cidr_block_netnum.application)
  availability_zone               = data.aws_availability_zones.all.names[count.index]
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = false
  tags                            = { Name = "application-${data.aws_availability_zones.all.names[count.index]}" }
}

resource "aws_route_table_association" "application" {
  count          = 3
  subnet_id      = aws_subnet.application[count.index].id
  route_table_id = aws_route_table.application[count.index].id
}

resource "aws_route_table" "application" {
  count  = 3
  vpc_id = aws_vpc.main.id
  tags   = { Name = "application-route-table" }
}

data "aws_vpc_endpoint" "network_firewall" {
  count  = 3
  vpc_id = aws_vpc.main.id
  state  = "available"

  tags = {
    Firewall                  = aws_networkfirewall_firewall.main[count.index].arn
    AWSNetworkFirewallManaged = "true"
  }
}

resource "aws_route" "application_nat_gateway" {
  count                  = 3
  route_table_id         = element(aws_route_table.application.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id        = data.aws_vpc_endpoint.network_firewall[count.index].id
  # vpc_endpoint_id        = aws_networkfirewall_firewall.main[count.index].firewall_status.sync_states.attachment.endpoint_id

  timeouts {
    create = "5m"
  }
}

// Data Subnets
resource "aws_subnet" "data" {
  count                           = 3
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = cidrsubnet(aws_vpc.main.cidr_block, 7, count.index + local.subnet_cidr_block_netnum.data)
  availability_zone               = data.aws_availability_zones.all.names[count.index]
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = false
  tags                            = { Name = "data-${data.aws_availability_zones.all.names[count.index]}" }
}

resource "aws_route_table_association" "data" {
  count          = 3
  subnet_id      = aws_subnet.data[count.index].id
  route_table_id = aws_route_table.data[count.index].id
}

resource "aws_route_table" "data" {
  count  = 3
  vpc_id = aws_vpc.main.id
  tags   = { Name = "data-route-table" }
}
