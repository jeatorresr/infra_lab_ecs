variable "nlb_name" {
  description = "Name of the Network Load Balancer"
  type        = string
}

variable "internal" {
  description = "Set to true for an internal NLB, false for a public one"
  type        = bool
  default     = false
}

variable "subnet_ids" {
  description = "List of subnet IDs where the NLB will be deployed"
  type        = list(string)
}

variable "vpc_id" {
  description = "ID of the VPC where the NLB and target group will be created"
  type        = string
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for the NLB"
  type        = bool
  default     = false
}

variable "protocol" {
  description = "Protocol used by the listener and target group (e.g., TCP)"
  type        = string
  default     = "TCP"
}

variable "listener_port" {
  description = "Port on which the NLB will listen for incoming traffic"
  type        = number
  default     = 80
}

variable "target_port" {
  description = "Port on which the container or application is listening"
  type        = number
  default     = 80
}
