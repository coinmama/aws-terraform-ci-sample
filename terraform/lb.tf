resource "aws_lb" "service" {
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.lb.id]
  drop_invalid_header_fields = false
  idle_timeout               = 30
  ip_address_type            = "ipv4"
  subnets                    = data.aws_subnet_ids.all.ids
  tags                       = merge(local.aws_tags, { Name : "${var.svc_name}.service.elasticloadbalancingloadbalancer" })
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.service.arn
  port              = var.svc_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service.arn
  }
}

resource "aws_lb_target_group" "service" {
  port        = var.svc_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  stickiness {
    type    = "lb_cookie"
    enabled = false
  }
  
  tags = merge(local.aws_tags, { Name : "${var.svc_name}.service.elasticloadbalancing.targetgroup" })
}
