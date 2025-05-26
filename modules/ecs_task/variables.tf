variable "ecs_name" {}
variable "cluster_arn" {}
variable "image" {}
variable "container_name" {}
variable "container_port" {
  type    = number
  default = 80
}
variable "cpu" {
  type    = string
  default = "256"
}
variable "memory" {
  type    = string
  default = "512"
}
variable "subnet_ids" {
  type = list(string)
}
variable "security_group_id" {}
variable "desired_count" {
  type    = number
  default = 1
}
variable "target_group_arn" {}
variable "log_group" {}
variable "log_region" {}
variable "log_prefix" {}
variable "nlb_listener_dependency" {}
