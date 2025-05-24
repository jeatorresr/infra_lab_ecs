resource "aws_security_group" "lb_to_api_gw" {
  name        = "apigw-to-nlb"
  description = "Allow API Gateway to talk to NLB"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow API Gateway VPC Link to NLB target port"
    from_port   = var.nlb_port
    to_port     = var.nlb_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "apigw-to-nlb"
  }
}

resource "aws_apigatewayv2_vpc_link" "nlb_link" {
  name               = "${var.name_vpc_link}"
  subnet_ids         = var.subnet_ids
  security_group_ids = [var.security_group_id]
}

resource "aws_api_gateway_rest_api" "api" {
  name        = "${var.name_vpc_link}-api"
  description = "API Gateway exposing NLB"
}

resource "aws_api_gateway_resource" "nlb_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = var.path
}

resource "aws_api_gateway_method" "get" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.nlb_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "nlb_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.nlb_resource.id
  http_method             = aws_api_gateway_method.get.http_method
  integration_http_method = "GET"
  type                    = "HTTP"
  uri                     = var.nlb_uri
  connection_type         = "VPC_LINK"
  connection_id           = aws_apigatewayv2_vpc_link.nlb_link.id
}

resource "aws_api_gateway_method_response" "method_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.nlb_resource.id
  http_method = aws_api_gateway_method.get.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.nlb_resource.id
  http_method = aws_api_gateway_method.get.http_method
  status_code = "200"
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on  = [aws_api_gateway_integration_response.integration_response]
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_stage" "prod" {
  rest_api_id    = aws_api_gateway_rest_api.api.id
  deployment_id  = aws_api_gateway_deployment.deployment.id
  stage_name     = "prod"

  tags = {
    Environment = "production"
  }
}
