output "vpc_id" {
  value = aws_vpc.main.id
}
output "public_subnet" {
  value = aws_subnet.public
}
output "private_subnet" {
  value = aws_subnet.private
}
output "private_rt" {
  value = aws_route_table.private
}
output "public_rt" {
  value = aws_route_table.public
}