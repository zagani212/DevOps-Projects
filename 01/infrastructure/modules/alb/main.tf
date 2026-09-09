resource "aws_lb" "alb" {
  name               = "${var.name}-lb-tf"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [var.sg]
  subnets            = var.subnets

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.id
  #   prefix  = "test-lb"
  #   enabled = true
  # }
  
}

resource "aws_lb_target_group" "target_group" {
  name     = "tf-${var.name}-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 10
    interval            = 30
    path                = "/"
    matcher             = "200"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}