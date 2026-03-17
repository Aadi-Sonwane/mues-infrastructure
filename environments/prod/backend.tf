terraform {
  backend "s3" {
    bucket         = var.bucket_name # Change this to your S3 bucket name
    key            = "${var.environment}/terraform.tfstate"
    region         = var.region
    encrypt        = true
    dynamodb_table = var.dynamodb_table # Prevents concurrent runs
  }
}