resource "aws_launch_template" "launch_template" {
  name = var.name

  image_id = "ami-0e1c4170d9c01184b"

  instance_type = "t3.micro"

  key_name = var.key_name

  dynamic "iam_instance_profile" {
    for_each = var.iam_instance_profile != null ? [var.iam_instance_profile] : []
    content {
      name = var.iam_instance_profile
    }
  }

  vpc_security_group_ids = [var.sg]

  user_data = base64encode(templatefile("${path.module}/${var.script_name}", {
    nginx_config       = templatefile("${path.module}/nginx.conf", {
      backend_private_ip = var.app_lb_dns_name
    })
  }))

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.name}-instance"
    }
  }
}

resource "aws_autoscaling_group" "bar" {
  name                      = "${var.name}-asg"
  max_size                  = 1
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  # health_check_type         = "EC2"
  desired_capacity          = 1
  force_delete              = true
  vpc_zone_identifier       = var.subnets

  target_group_arns = [var.alb_target_group]

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  # instance_maintenance_policy {
  #   min_healthy_percentage = 90
  #   max_healthy_percentage = 120
  # }
}