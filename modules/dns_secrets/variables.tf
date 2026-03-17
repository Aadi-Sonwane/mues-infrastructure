variable "env" {
  type = string
}

variable "domain_name" {
  type        = string
  description = "The root domain name (e.g., rankhex.in)"
}

variable "alb_dns_name" {
  type        = string
  description = "DNS name of the Public ALB from the LB module"
}

variable "alb_zone_id" {
  type        = string
  description = "Canonical Hosted Zone ID of the ALB"
}

variable "mongodb_url" {
  type        = string
  sensitive   = true
  description = "The external MongoDB connection string"
}