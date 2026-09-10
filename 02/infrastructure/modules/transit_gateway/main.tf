resource "aws_ec2_transit_gateway" "main" {
  description = "example"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
}

resource "aws_ec2_transit_gateway_route_table" "main" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_a" {
  subnet_ids         = var.subnet_a
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = var.vpc_id_a
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_b" {
  subnet_ids         = var.subnet_b
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = var.vpc_id_b
}

resource "aws_ec2_transit_gateway_route_table_association" "vpc_a" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_a.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main.id
}

resource "aws_ec2_transit_gateway_route_table_association" "vpc_b" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_b.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main.id
}

resource "aws_ec2_transit_gateway_route" "to_vpc_a" {
  destination_cidr_block         = var.vpc_cidr_a
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_a.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main.id
}

resource "aws_ec2_transit_gateway_route" "to_vpc_b" {
  destination_cidr_block         = var.vpc_cidr_b
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_b.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main.id
}

resource "aws_route" "vpc_a" {
  count                  = length(var.rt_a)
  route_table_id         = var.rt_a[count.index]
  destination_cidr_block = var.vpc_cidr_b
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
}

resource "aws_route" "vpc_b" {
  count                  = length(var.rt_b)
  route_table_id         = var.rt_b[count.index]
  destination_cidr_block = var.vpc_cidr_a
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
}