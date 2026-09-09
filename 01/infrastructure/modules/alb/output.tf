output "target_group" {
  value = aws_lb_target_group.target_group.id
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}