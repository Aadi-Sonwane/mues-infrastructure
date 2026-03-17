variable "env" {}
variable "region" {}
variable "vpc_cidr" {}
variable "public_subnet_cidrs" { type = list(string) }
variable "private_subnet_cidrs" { type = list(string) }
variable "availability_zones" { type = list(string) }
variable "instance_type" {}
variable "ami_id" {}
variable "desired_capacity" { type = number }
variable "max_size" { type = number }
variable "min_size" { type = number }
variable "domain_name" {}
variable "mongodb_url" {}