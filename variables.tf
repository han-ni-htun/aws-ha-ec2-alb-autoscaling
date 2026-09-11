variable "aws_region" {
  description = "AWS region for the infrastructure"
  type        = string
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI profile used by Terraform"
  type        = string
}

variable "availability_zones" {
  description = "Availability Zones used by the architecture"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public ALB subnets"
  type        = list(string)
}

variable "dashboard_subnet_cidrs" {
  description = "CIDR blocks for private Dashboard subnets"
  type        = list(string)
}

variable "counting_subnet_cidrs" {
  description = "CIDR blocks for private Counting subnets"
  type        = list(string)
}

variable "dashboard_instance_type" {
  description = "EC2 instance type for Dashboard instances"
  type        = string
}

variable "counting_instance_type" {
  description = "EC2 instance type for Counting instances"
  type        = string
}

variable "dashboard_min_size" {
  description = "Minimum number of Dashboard instances"
  type        = number
}

variable "dashboard_desired_capacity" {
  description = "Desired number of Dashboard instances"
  type        = number
}

variable "dashboard_max_size" {
  description = "Maximum number of Dashboard instances"
  type        = number
}

variable "counting_min_size" {
  description = "Minimum number of Counting instances"
  type        = number
}

variable "counting_desired_capacity" {
  description = "Desired number of Counting instances"
  type        = number
}

variable "counting_max_size" {
  description = "Maximum number of Counting instances"
  type        = number
}