terraform {
  backend "s3" {
    bucket  = "mues-terraform-state-2026" # Use your actual bucket name
    key     = "env/dev/terraform.tfstate"
    region  = "ap-south-1"
    encrypt = true

    # This replaces DynamoDB for state locking
    # Requires Terraform v1.9.0+ and AWS Provider v5.58.0+
    use_lockfile = true
  }
}