resource "aws_launch_template" "app" {
  name = "app"
  image_id = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [var.sg]
  user_data = filebase64("${path.module}/${var.script_name}")
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "app-instance"
    }
  }
}

resource "aws_autoscaling_group" "app" {
  name                      = "asg_app"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 10
  health_check_type         = "EC2"
  # health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  target_group_arns = [var.tg]
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }
  vpc_zone_identifier       = var.subnet_ids
}