provider "aws" {
  region = "us-east-1"
}

# Módulo de VPC
module "vpc" {
  source           = "./modules/vpc"
  name             = var.vpc_name
  cidr_block       = var.vpc_cidr_block
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
}
