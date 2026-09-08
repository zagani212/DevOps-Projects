resource "aws_launch_template" "launch_template" {
  name = var.name

  image_id = "ami-0e1c4170d9c01184b"

  instance_type = "t3.micro"

  key_name = var.key_name

  vpc_security_group_ids = [var.sg]

  user_data = filebase64("${path.module}/${var.script_name}")
}

resource "aws_autoscaling_group" "bar" {
  name                      = "${var.name}-asg"
  max_size                  = 2
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  vpc_zone_identifier       = var.subnets

  target_group_arns = [var.alb_target_group]

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  instance_maintenance_policy {
    min_healthy_percentage = 90
    max_healthy_percentage = 120
  }
}