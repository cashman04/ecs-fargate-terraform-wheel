resource "aws_ecs_task_definition" "main" {
  family = "${var.name}-${var.environment}-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([
    {
      name        = "${var.name}-${var.environment}-container"
      image       = "${aws_ecr_repository.main.repository_url}:latest"
      essential   = true
      environment = var.environment_variables
      portMappings = [{
        protocol      = "tcp"
        containerPort = var.container_port
        hostPort      = var.container_port
      }]
    }
  ])
}
