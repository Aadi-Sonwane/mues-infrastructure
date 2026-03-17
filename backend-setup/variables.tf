# backend-setup/variables.tf

variable "region" {
  type    = string
  default = "ap-south-1"
  description = "region"
}

variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket to store state"
}

variable "lock_table_name" {
  type        = string
  default     = "mues-terraform-lock"
  description = "The name of the DynamoDB table for state locking"
}

variable "project_name" {
  type        = string
  default     = "Mues-Project-Backend"
  description = "Project name for tagging resources"
}

variable "managed_by" {
  type        = string
  default     = "Ganesh-Kharat"
  description = "Tag to indicate resource is managed by Terraform"
}