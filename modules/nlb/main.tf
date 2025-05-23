resource "aws_lb" "nlb" {
  name               = var.nlb_name
  internal           = var.internal
  load_balancer_type = "network"
  subnets            = var.subnet_ids

  enable_deletion_protection = var.enable_deletion_protection

  tags = {
    Name = var.nlb_name
  }
}

resource "aws_lb_target_group" "tg" {
  name        = "${var.nlb_name}-tg"
  port        = var.target_port
  protocol    = var.protocol
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    protocol = var.protocol
    port     = "traffic-port"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = var.listener_port
  protocol          = var.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
