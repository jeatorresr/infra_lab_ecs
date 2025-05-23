output "nlb_dns_name" {
  description = "DNS"
  value       = aws_lb.nlb.dns_name
}

output "target_group_arn" {
  description = "Target Group ARN"
  value       = aws_lb_target_group.tg.arn
}

output "listener_arn" {
  description = "Listener ARN"
  value       = aws_lb_listener.listener.arn
}

output "lb_arn" {
  description = "NLB ALB"
  value       = aws_lb.nlb.arn
}
