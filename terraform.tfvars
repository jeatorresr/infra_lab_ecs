vpc_name        = "vpc_lab_ecs"
vpc_cidr_block  = "10.0.0.0/16"
public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
repository_name = "ecr_lab_ecs"
nlb_name        = "nlb"
cluster_name = "cluster_lab_ecs"
repository_read_write_access_arns = [ "arn:aws:iam::337918032209:role/api-taller-oidc-github" ]
