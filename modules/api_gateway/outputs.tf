output "api_url" {
  value = "https://${aws_api_gateway_rest_api.api.id}.execute-api.${var.aws_region}.amazonaws.com/prod/${var.path}"
}

output "security_group_id" {
  value = aws_security_group.lb_to_api_gw.id
}
