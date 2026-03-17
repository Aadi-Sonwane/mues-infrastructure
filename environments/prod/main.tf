terraform {
  required_version = ">= 1.10.0"

  # Remote Backend: Ensures team collaboration and state safety
  backend "s3" {
    bucket         = "your-unique-tf-state-bucket" # Use the bucket from backend-setup
    key            = "env/dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Pessimistic constraint: allows 5.x, but not 6.x
    }
  }
}

provider "aws" {
  region = var.region

  # PRO-TIP: Default tags ensure every resource created is traceable
  default_tags {
    tags = {
      Environment = var.env
      Project     = "TwoTierApp"
      ManagedBy   = "Terraform"
      Owner       = "PlatformTeam"
    }
  }
}


# 1. Networking (High Availability Mode)
module "vpc" {
  source               = "../../modules/vpc"
  env                  = var.env
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  single_nat_gateway   = false # PROD: One NAT per AZ for fault tolerance
}

# 2. DNS & Secrets
module "dns_secrets" {
  source       = "../../modules/dns_secrets"
  env          = var.env
  domain_name  = var.domain_name
  mongodb_url  = var.mongodb_url
  alb_dns_name = module.lb.alb_dns_name
  alb_zone_id  = module.lb.alb_zone_id
}

# 3. Security
module "security" {
  source   = "../../modules/security"
  env      = var.env
  vpc_id   = module.vpc.vpc_id
  vpc_cidr = module.vpc.vpc_cidr
}

# 4. Load Balancing
module "lb" {
  source          = "../../modules/lb"
  env             = var.env
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnet_ids
  private_subnets = module.vpc.private_subnet_ids
  alb_sg_id       = module.security.alb_sg_id
  certificate_arn = module.dns_secrets.certificate_arn
}

# 5. Compute (Scale-Out Mode)
module "compute" {
  source                = "../../modules/compute"
  env                   = var.env
  region                = var.region
  vpc_id                = module.vpc.vpc_id
  private_subnets       = module.vpc.private_subnet_ids
  react_sg_id           = module.security.react_sg_id
  django_sg_id          = module.security.django_sg_id
  instance_profile_name = module.security.instance_profile_name
  react_tg_arn          = module.lb.react_tg_arn
  django_tg_arn         = module.lb.django_tg_arn
  instance_type         = var.instance_type
  ami_id                = var.ami_id
  desired_capacity      = var.desired_capacity
  max_size              = var.max_size
  min_size              = var.min_size
  mongo_url_param_name  = module.dns_secrets.mongo_param_name
}