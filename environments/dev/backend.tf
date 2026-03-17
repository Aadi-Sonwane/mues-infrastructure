terraform {
  backend "s3" {
    # Replace with the EXACT bucket name created in backend-setup
    bucket         = "mues-terraform-state-2026-prod" 
    key            = "env/dev/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    # Replace with the EXACT DynamoDB table name
    dynamodb_table = "mues-terraform-lock" 
  }
}