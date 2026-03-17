variable "vpc_id" {
  description = "The VPC ID where security groups will be created"
  type        = string
}

variable "vpc_cidr" {
  description = "The VPC CIDR block for internal traffic rules"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}