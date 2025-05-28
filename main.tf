provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source          = "./modules/vpc"
  name            = var.vpc_name
  cidr_block      = var.vpc_cidr_block
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "ecr" {
  source                            = "./modules/ecr"
  repository_name                   = var.repository_name
  repository_image_tag_mutability   = var.repository_image_tag_mutability
  repository_force_delete           = var.repository_force_delete
  repository_image_scan_on_push     = var.repository_image_scan_on_push
  repository_read_write_access_arns = var.repository_read_write_access_arns
}

module "nlb" {
  source     = "./modules/nlb"
  nlb_name   = var.nlb_name
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
}

module "aws_ecs_cluster" {
  source       = "./modules/ecs_cluster"
  cluster_name = var.cluster_name
}

module "api_gateway" {
  source            = "./modules/api_gateway"
  name_vpc_link     = var.name_vpc_link
  path              = var.path
  subnet_ids        = module.vpc.public_subnet_ids
  security_group_id = module.api_gateway.security_group_id
  nlb_uri           = "http://${module.nlb.nlb_dns_name}:80"
  vpc_id            = module.vpc.vpc_id
  nlb_port          = var.nlb_port
  nlb_arn           = module.nlb.lb_arn
}

module "ecs_task" {
  source                  = "./modules/ecs_task"
  ecs_name                = var.ecs_name
  cluster_arn             = module.aws_ecs_cluster.cluster_arn
  image                   = "latest"
  container_name          = var.container_name
  container_port          = 80
  cpu                     = "256"
  memory                  = "512"
  subnet_ids              = module.vpc.private_subnet_ids
  desired_count           = 1
  target_group_arn        = module.nlb.target_group_arn
  log_group               = module.aws_ecs_cluster.log_group_name
  log_region              = var.aws_region
  log_prefix              = "lab"
  nlb_listener_dependency = module.nlb
  security_group_id       = module.vpc.security_group_id
}