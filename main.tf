provider "aws" {
  region = "us-east-1"
}

# Módulo de VPC
module "vpc" {
  source          = "./modules/vpc"
  name            = var.vpc_name
  cidr_block      = var.vpc_cidr_block
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "ecr" {
  source                          = "./modules/ecr"
  repository_name                 = var.repository_name
  repository_image_tag_mutability = var.repository_image_tag_mutability
  repository_force_delete         = var.repository_force_delete
  repository_image_scan_on_push   = var.repository_image_scan_on_push
}

module "nlb" {
  source      = "./modules/nlb"
  nlb_name    = var.nlb_name
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnet_ids
}
