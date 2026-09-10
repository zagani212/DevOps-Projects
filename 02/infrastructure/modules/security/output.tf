output "bastion_sg" {
  value = aws_security_group.bastion_sg.id
}
output "app_sg" {
  value = aws_security_group.app_sg.id
}