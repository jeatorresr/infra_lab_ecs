variable "name_vpc_link" {
  description = "Base name for the API Gateway and VPC link"
  type        = string
}

variable "path" {
  description = "API path that will route to the NLB"
  type        = string
  default     = "nlb"
}

variable "subnet_ids" {
  description = "List of subnet IDs for the VPC Link"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group for the VPC Link to access the NLB"
  type        = string
}

variable "nlb_uri" {
  description = "URI of the NLB (http://<dns>:<port>)"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type = string
  default = "us-east-1"
}

variable "vpc_id" {
  description = "VPC where the NLB is deployed"
  type        = string
}

variable "nlb_port" {
  description = "Port where the NLB is listening"
  type        = number
}

variable "nlb_arn" {
  description = "NLB ARN"
  type = string
}