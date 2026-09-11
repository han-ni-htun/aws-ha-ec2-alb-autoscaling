locals {
  lb_name_prefix = "ha-ec2"
}

resource "aws_lb" "dashboard" {
  name               = "${local.lb_name_prefix}-dashboard-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_alb.id]

  subnets = [
    aws_subnet.public[0].id,
    aws_subnet.public[1].id
  ]

  tags = {
    Name = "${var.project_name}-dashboard-alb"
  }
}

resource "aws_lb_target_group" "dashboard" {
  name     = "${local.lb_name_prefix}-dashboard-tg"
  port     = 9002
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
  }

  tags = {
    Name = "${var.project_name}-dashboard-tg"
  }
}

resource "aws_lb_listener" "dashboard_http" {
  load_balancer_arn = aws_lb.dashboard.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashboard.arn
  }
}

resource "aws_lb" "counting" {
  name               = "${local.lb_name_prefix}-counting-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.internal_alb.id]

  subnets = [
    aws_subnet.counting_private[0].id,
    aws_subnet.counting_private[1].id
  ]

  tags = {
    Name = "${var.project_name}-counting-alb"
  }
}

resource "aws_lb_target_group" "counting" {
  name     = "${local.lb_name_prefix}-counting-tg"
  port     = 9003
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
  }

  tags = {
    Name = "${var.project_name}-counting-tg"
  }
}

resource "aws_lb_listener" "counting_http" {
  load_balancer_arn = aws_lb.counting.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.counting.arn
  }
}