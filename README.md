# 📦 AWS Infrastructure - ECR,ECS, NLB and API Gateway

## Description

This project contains the Terraform templates and a GitHub Action workflow to deploy the following infrastructure on AWS:

- VPC: VPC with private and public subnets to isolate the network traffic.
- ECR: Private Docker images repository.
- NLB: Balance traffic to tasks in ECS.
- ECS Fargate: Serverless service for running containers.
- API Gateway: Exposes the public endpoint.

## Table of Contents

- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Architecture Diagram](#architecture-diagram)
- [Configuration](#configuration-wrench)
  - [1. Set up AWS Credentials](#1-set-up-aws-credentials)
  - [2. Create parameter on AWS SSM Parameter Store](#2-create-parameter-on-aws-ssm-parameter-store)
- [Reusable Modules](#reusable-modules)
- [Deployment](#deployment-bricks)
  - [1. Deployment Flow](#1-deployment-flow)
  - [2. Modify the Workflow](#2-modify-the-workflow)
  - [3. Push Changes](#3-push-changes)
- [Resources Created](#resources-created-rocket)
- [Cleanup](#cleanup-wastebasket)
- [Contribution](#contribution)
- [Authors](#authors)

## Project Structure

- Modules:
├── api_gateway        # Exposes the NLB via API Gateway (HTTP or REST)
├── ecr                # Creates an ECR repository for Docker images
├── ecs_cluster        # Defines the ECS cluster (Fargate-compatible)
├── ecs_task           # Creates the Task Definition + ECS Service
├── nlb                # Configures the Network Load Balancer and Target Group
└── vpc                # Sets up the base VPC and subnets

- GitHub Workflow:
  - .github/workflows/deploy.yml: Automates the deployment process using AWS CLI and GitHub Actions.

## Prerequisites

Before setting up this project, ensure you have the following:

- An **`AWS Account`** with permissions to use **`IAM`**, **`ECS`**, **`ECR`**, **`VPC`**, **`NLB`**, **`API Gateway`**, and **`CloudWatch`**.
- **`AWS CLI`** installed and configured.

## Architecture Diagram

![Architecure Diagram](./Architecture%20Diagram.drawio.png)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/jeatorresr/infra_lab_ecs.git
```
2. Create your own repository, copy the files and commit the new changes to deploy the infrastructure.

## Configuration :wrench:

### 1. Set up AWS Credentials

Create an IAM role that includes permissions to perform actions on VPC, ECR, ECS, NLB, API Gateway, and CloudWatch, with a trust policy that allows authentication from GitHub.

### 2. Create parameter on AWS SSM Parameter Store

Since the Docker image tag varies with each new execution, it was decided to manage this parameter through the SSM Parameter Store. For this step, enter the console and create this parameter **lab-ecs**, which will automatically store the ECR image URI. This parameter will be automatically filled in when the CI pipeline is executed, located at https://github.com/jeatorresr/lab_ecs.git

## Reusable Modules

1. api_gateway
    - Creates an API Gateway integrated with the NLB via VPC Link.
    - Used to securely expose ECS services.

2. ecr
    - Provisions an Amazon ECR repository to store Docker images.
    - Includes image scanning on push.

3. ecs_cluster
    - Deploys a scalable ECS cluster configured for Fargate.
    - Supports multiple ECS services.

4. ecs_task
    - Manages the ECS Task Definition and ECS Fargate Service.
    - Configurable logging, ports, and dynamic image updates.
    - Links with a pre-created NLB target group.

5. nlb
    - Sets up a Network Load Balancer with a target group (ip type).
    - Listens for TCP traffic from API Gateway or external clients.

6. vpc
    - Creates a basic VPC with public subnets.
    - Shared by ECS, NLB, and the API Gateway VPC Link.

## Deployment :bricks:

### Using GitHub Actions

The deployment is fully automated through a GitHub Action. The workflow triggers on pushes to the main branch.

#### 1. Deployment Flow

1. Provision base infrastructure:
    - VPC
    - NLB
    - API Gateway
    - ECS Cluster
    - ECR Repository

2. Build and push Docker image to ECR from a separate repository https://github.com/jeatorresr/lab_ecs.git

3. Create and update the ECS Task Definition with the new image tag.

4. Deploy the ECS Service attached to the NLB target group.

5. API Gateway routes external traffic to the NLB, which forwards to ECS.

#### 2. Modify the Workflow:

Ensure the correct role ARN and AWS region are set in .github/workflows/deploy.yml.
```bash
- name: Configure AWS credentials
    uses: aws-actions/configure-aws-credentials@v2
    with:
      role-to-assume: arn:aws:iam::<AWS_ACCOUNT_ID>:role/<AWS_GITHUB_ROLE_NAME>
      aws-region: <AWS_REGION>
```

To provision the base infrastructure, you need to remove the **ecs_task** module from the **main.tf** file.
```bash
module "ecs_task" {
  source                  = "./modules/ecs_task"
  ecs_name                = var.ecs_name
  cluster_arn             = module.aws_ecs_cluster.cluster_arn
  image                   = data.aws_ssm_parameter.image_uri.value
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
```

#### 3. Push Changes:

Push your changes to the main branch to trigger the deployment:

```bash
git add .
git commit -m "Deploy infrastructure"
git push origin main
```

After compiling the image found in this repository **https://github.com/jeatorresr/lab_ecs.git**, add the module again to the main.tf file and commit the changes.

## Resources Created :rocket:

- ECS task: Container based application.
- API Gateway: Exposes the ECS via an HTTP endpoint.

## Cleanup :wastebasket:

To remove the resources, run the GitHub workflow on the branch **hotfix/destroy_infra**

## Contribution

1. Fork the project.
2. Create a new branch (git checkout -b feature-branch).
3. Make your changes and commit them (git commit -am 'Add new feature').
4. Push to the branch (git push origin feature-branch).
5. Open a Pull Request.


### Authors
- Jenifer Andrea Torres
