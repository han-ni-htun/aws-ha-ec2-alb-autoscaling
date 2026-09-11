resource "aws_autoscaling_group" "dashboard" {
  name_prefix = "ha-dashboard-asg-"

  min_size         = var.dashboard_min_size
  desired_capacity = var.dashboard_desired_capacity
  max_size         = var.dashboard_max_size

  vpc_zone_identifier = [
    aws_subnet.dashboard_private[0].id,
    aws_subnet.dashboard_private[1].id
  ]

  target_group_arns = [
    aws_lb_target_group.dashboard.arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.dashboard.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-dashboard"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "counting" {
  name_prefix = "ha-counting-asg-"

  min_size         = var.counting_min_size
  desired_capacity = var.counting_desired_capacity
  max_size         = var.counting_max_size

  vpc_zone_identifier = [
    aws_subnet.counting_private[0].id,
    aws_subnet.counting_private[1].id
  ]

  target_group_arns = [
    aws_lb_target_group.counting.arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.counting.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-counting"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "dashboard_requests" {
  name                   = "dashboard-request-target"
  autoscaling_group_name = aws_autoscaling_group.dashboard.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"

      resource_label = "${aws_lb.dashboard.arn_suffix}/${aws_lb_target_group.dashboard.arn_suffix}"
    }

    target_value = 1000
  }
}

resource "aws_autoscaling_policy" "counting_cpu" {
  name                   = "counting-cpu-target"
  autoscaling_group_name = aws_autoscaling_group.counting.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 60.0
  }
}