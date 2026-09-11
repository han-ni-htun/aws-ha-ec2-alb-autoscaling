output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "dashboard_alb_dns_name" {
  description = "Public DNS name of the internet-facing Dashboard ALB"
  value       = aws_lb.dashboard.dns_name
}

output "counting_alb_dns_name" {
  description = "Private DNS name of the internal Counting ALB"
  value       = aws_lb.counting.dns_name
}

output "dashboard_target_group_arn" {
  description = "ARN of the Dashboard target group"
  value       = aws_lb_target_group.dashboard.arn
}

output "counting_target_group_arn" {
  description = "ARN of the Counting target group"
  value       = aws_lb_target_group.counting.arn
}

output "dashboard_asg_name" {
  description = "Name of the Dashboard Auto Scaling Group"
  value       = aws_autoscaling_group.dashboard.name
}

output "counting_asg_name" {
  description = "Name of the Counting Auto Scaling Group"
  value       = aws_autoscaling_group.counting.name
}