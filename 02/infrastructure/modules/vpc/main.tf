resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.name
  }
}

resource "aws_vpc_dhcp_options" "main" {
  domain_name          = "ec2.internal"
  domain_name_servers  = ["AmazonProvidedDNS"]

  tags = {
    Name = "main-dhcp"
  }
}

resource "aws_vpc_dhcp_options_association" "bastion" {
  vpc_id              = aws_vpc.main.id
  dhcp_options_id     = aws_vpc_dhcp_options.main.id
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block = var.public_subnet_cidr[count.index]
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block = var.private_subnet_cidr[count.index]
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_eip" "ngw_eip" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "ngw" {
  count = length(aws_subnet.private) > 0 ? 1 : 0
  allocation_id = aws_eip.ngw_eip.id
  subnet_id     = length(aws_subnet.public) > 1 ? aws_subnet.public[1].id : aws_subnet.public[0].id

  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "public" {
  count = length(aws_subnet.public)
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "public_igw" {
  count = length(aws_subnet.public)
  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table" "private" {
  count = length(aws_subnet.private)
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "private_nat" {
  count = length(aws_subnet.private)
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw[0].id
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

