data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_template" "counting" {
  name_prefix   = "ha-counting-"
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = var.counting_instance_type

  vpc_security_group_ids = [
    aws_security_group.counting.id
  ]

  user_data = base64encode(
    file("${path.module}/user-data/counting.sh")
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.project_name}-counting"
    }
  }

  tags = {
    Name = "${var.project_name}-counting-lt"
  }
}

resource "aws_launch_template" "dashboard" {
  name_prefix   = "ha-dashboard-"
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = var.dashboard_instance_type

  vpc_security_group_ids = [
    aws_security_group.dashboard.id
  ]

  user_data = base64encode(
    templatefile(
      "${path.module}/user-data/dashboard.sh",
      {
        counting_alb_dns = aws_lb.counting.dns_name
      }
    )
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.project_name}-dashboard"
    }
  }

  tags = {
    Name = "${var.project_name}-dashboard-lt"
  }
}