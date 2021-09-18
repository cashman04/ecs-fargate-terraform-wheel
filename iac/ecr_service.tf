resource "aws_ecs_service" "main" {
 name                               = "${var.name}-${var.environment}-service"
 cluster                            = aws_ecs_cluster.main.id
 task_definition                    = aws_ecs_task_definition.main.arn
 desired_count                      = 2
 deployment_minimum_healthy_percent = 50
 deployment_maximum_percent         = 200
 launch_type                        = "FARGATE"
 scheduling_strategy                = "REPLICA"
 depends_on    = [ aws_alb_target_group.main, aws_lb.main ]
 
 network_configuration {
   security_groups  = [ aws_security_group.alb.id, aws_security_group.ecs_tasks.id ] 
   subnets          = [ aws_subnet.private[0].id, aws_subnet.private[1].id ]
   assign_public_ip = false
 }

 load_balancer {
   target_group_arn = aws_alb_target_group.main.arn
   container_name   = "${var.name}-${var.environment}-container"
   container_port   = var.container_port
 }
 
 lifecycle {
   ignore_changes = [task_definition, desired_count]
 }
}