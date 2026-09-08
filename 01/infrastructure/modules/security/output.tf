output "instance_nginx_sg_id" {
  value = aws_security_group.instance_nginx_sg.id
}
output "nginx_alb_sg_id" {
  value = aws_security_group.nginx_alb_sg.id
}