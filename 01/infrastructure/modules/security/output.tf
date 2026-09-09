output "instance_nginx_sg_id" {
  value = aws_security_group.instance_nginx_sg.id
}
output "instance_app_sg_id" {
  value = aws_security_group.instance_app_sg.id
}
output "nginx_alb_sg_id" {
  value = aws_security_group.nginx_alb_sg.id
}
output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}