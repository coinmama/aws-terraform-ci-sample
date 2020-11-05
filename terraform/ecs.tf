resource "aws_ecs_cluster" "main" {
  name               = "${var.svc_name}-ecs-cluster"
  capacity_providers = ["FARGATE"]
  tags               = local.aws_tags
}

resource "aws_ecs_task_definition" "task" {
  family = var.svc_name

  container_definitions = templatefile("${path.module}/task.json", {
    svc_name : var.svc_name,
    container : var.svc_container,
    svc_port : local.container_port
  })

  network_mode = "awsvpc"
  cpu          = "256"
  memory       = "512"
  tags         = local.aws_tags
}

resource "aws_ecs_service" "service" {
  name            = var.svc_name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.task.id
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnet_ids.all.ids
    security_groups  = [aws_security_group.lb_targets.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.service.arn
    container_name   = var.svc_name
    container_port   = local.container_port
  }

  depends_on = [
    aws_lb_listener.http
  ]
}