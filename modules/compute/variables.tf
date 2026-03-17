variable "env" {}
variable "vpc_id" {}
variable "region" {}

variable "private_subnets" { type = list(string) }
variable "react_sg_id" { type = string }
variable "django_sg_id" { type = string }
variable "instance_profile_name" { type = string }
variable "react_tg_arn" { type = string }
variable "django_tg_arn" { type = string }

variable "instance_type" { type = string }
variable "ami_id" { type = string }

# Scaling parameters
variable "desired_capacity" { type = number }
variable "max_size" { type = number }
variable "min_size" { type = number }

# SSM Parameter name for MongoDB URL
variable "mongo_url_param_name" { type = string }
