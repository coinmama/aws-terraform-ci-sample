data "aws_vpc" "main" {
  id = var.vpc_id
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.main.id
}

resource "aws_security_group" "lb" {
  name        = "lb.ec2.security-group"
  description = "${var.svc_name} LB"
  vpc_id      = data.aws_vpc.main.id
  tags        = local.aws_tags
}

resource "aws_security_group" "lb_targets" {
  name        = "lb-targets.ec2.security-group"
  description = "Target instances for ${var.svc_name} LB"
  vpc_id      = data.aws_vpc.main.id
  tags        = local.aws_tags
}

resource "aws_security_group_rule" "lb_ingress" {
  security_group_id = aws_security_group.lb.id
  description       = "World access to load balancer"
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
  protocol          = "TCP"
  from_port         = var.svc_port
  to_port           = var.svc_port
}

resource "aws_security_group_rule" "lb_egress" {
  security_group_id        = aws_security_group.lb.id
  description              = "Egress to target port"
  source_security_group_id = aws_security_group.lb_targets.id
  type                     = "egress"
  protocol                 = "TCP"
  from_port                = local.container_port
  to_port                  = local.container_port
}

resource "aws_security_group_rule" "lb_targets_ingress" {
  security_group_id        = aws_security_group.lb_targets.id
  description              = "Ingress to target port"
  source_security_group_id = aws_security_group.lb.id
  type                     = "ingress"
  protocol                 = "TCP"
  from_port                = local.container_port
  to_port                  = local.container_port
}

resource "aws_security_group_rule" "lb_targets_egress" {
  security_group_id = aws_security_group.lb_targets.id
  description       = "Egress to world"
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
}