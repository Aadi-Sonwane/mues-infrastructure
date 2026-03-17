terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = var.env
      Project     = var.project_name
      ManagedBy   = var.managed_by
      Owner       = var.owner
    }
  }
}

# 1. Networking Layer
module "vpc" {
  source               = "../../modules/vpc"
  env                  = var.env
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  single_nat_gateway   = true # Cost optimization for Dev
}

# 2. Security Layer (Firewalls & IAM)
module "security" {
  source   = "../../modules/security"
  env      = var.env
  vpc_id   = module.vpc.vpc_id
  vpc_cidr = module.vpc.vpc_cidr
}

# 3. DNS & Secrets (SSM & ACM)
module "dns_secrets" {
  source       = "../../modules/dns_secrets"
  env          = var.env
  domain_name  = var.domain_name
  mongodb_url  = var.mongodb_url
  alb_dns_name = module.lb.alb_dns_name
  alb_zone_id  = module.lb.alb_zone_id
}

# 4. Load Balancing (ALB & NLB)
module "lb" {
  source          = "../../modules/lb"
  env             = var.env
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnet_ids
  private_subnets = module.vpc.private_subnet_ids
  alb_sg_id       = module.security.alb_sg_id
  certificate_arn = module.dns_secrets.certificate_arn
}

# 5. Compute Layer (ASG with Mixed Instances)
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