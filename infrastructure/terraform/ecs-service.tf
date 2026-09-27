resource "aws_ecs_service" "shipping_dev" {
  name            = "shipping-api-dev"
  cluster         = aws_ecs_cluster.shipping_dev.id
  task_definition = aws_ecs_task_definition.shipping_dev.arn

  launch_type   = "FARGATE"
  desired_count = 0

  lifecycle {
    ignore_changes = [
      task_definition
    ]
  }

  network_configuration {
    subnets          = [aws_subnet.shipping_dev.id]
    security_groups  = [aws_security_group.shipping_dev.id]
    assign_public_ip = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.ecs_task_execution,
    aws_route_table_association.shipping_dev
  ]

  tags = {
    Project = "aws-cloud-native-cicd-lab"
  }
}