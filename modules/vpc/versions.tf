# modules/vpc/versions.tf
terraform {
  # Ensures the core Terraform binary is compatible
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # This ensures the module works with current AWS features
      version = ">= 5.0" 
    }
  }
}