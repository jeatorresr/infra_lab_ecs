terraform {
  backend "s3" {
    bucket  = "tfstate-lab-ecs"
    key     = "dev/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
