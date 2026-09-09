output "host" {
  value = aws_db_instance.default.address
}
output "port" {
  value = aws_db_instance.default.port
}
output "username" {
  value = aws_db_instance.default.username
}
