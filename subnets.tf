locals {
  subnet_cidr_block_netnum = {
    alb         = 25
    nat         = 45
    firewall    = 65
    application = 95
    data        = 115
  }
}

// Public Subnets
resource "aws_subnet" "alb" {
  count                           = 3
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = cidrsubnet(aws_vpc.main.cidr_block, 7, count.index + local.subnet_cidr_block_netnum.alb)
  availability_zone               = data.aws_availability_zones.all.names[count.index]
  map_public_ip_on_launch         = var.map_public_ip_on_launch
  assign_ipv6_address_on_creation = var.public_subnet_assign_ipv6_address_on_creation
  tags                            = { Name = "public-${data.aws_availability_zones.all.names[count.index]}" }
}

resource "aws_route_table_association" "alb" {
  count          = 3
  subnet_id      = aws_subnet.alb[count.index].id
  route_table_id = aws_route_table.alb[count.index].id
}

resource "aws_route_table" "alb" {
  count  = 3
  vpc_id = aws_vpc.main.id
  tags   = { Name = "public-route-table" }
}

// Nat Subnets
resource "aws_subnet" "nat" {
  count                           = 3
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = cidrsubnet(aws_vpc.main.cidr_block, 7, count.index + local.subnet_cidr_block_netnum.nat)
  availability_zone               = data.aws_availability_zones.all.names[count.index]
  map_public_ip_on_launch         = var.map_public_ip_on_launch
  assign_ipv6_address_on_creation = var.public_subnet_assign_ipv6_address_on_creation
  tags                            = { Name = "nat-${data.aws_availability_zones.all.names[count.index]}" }
}

resource "aws_route_table_association" "nat" {
  count          = 3
  subnet_id      = aws_subnet.nat[count.index].id
  route_table_id = aws_route_table.nat[count.index].id
}

resource "aws_route_table" "nat" {
  count  = 3
  vpc_id = aws_vpc.main.id
  tags   = { Name = "nat-route-table" }
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
