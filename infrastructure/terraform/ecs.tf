resource "aws_ecs_cluster" "shipping_dev" {
  name = "shipping-api-dev"

  tags = {
    Project = "aws-cloud-native-cicd-lab"
  }
}

resource "aws_security_group" "shipping_dev" {
  name        = "shipping-api-dev-task"
  description = "Security group for the shipping API DEV task"
  vpc_id      = data.aws_vpc.default.id

  # No ingress rules yet.

  egress {
    description = "Allow outbound traffic for image pulls and logging"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "shipping-api-dev-task"
    Project = "aws-cloud-native-cicd-lab"
  }
}

resource "aws_ecs_task_definition" "shipping_dev" {
  family                   = "shipping-api-dev"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "shipping-api"
      image     = "${aws_ecr_repository.shipping_api.repository_url}@sha256:3c8d35f5400667c2954e847afd96b808bd980bb43a9cb732ae2400a05be58ec9"
      essential = true

      healthCheck = {
        command = [
          "CMD-SHELL",
          "python -c \"import urllib.request; urllib.request.urlopen('http://127.0.0.1:8080/health', timeout=3)\""
        ]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 30
      }

      portMappings = [
        {
          containerPort = 8080
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.shipping_dev.name
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Project = "aws-cloud-native-cicd-lab"
  }
}

resource "aws_vpc_security_group_ingress_rule" "shipping_dev_from_laptop" {
  security_group_id = aws_security_group.shipping_dev.id

  description = "Allow shipping API access from my laptop"
  cidr_ipv4   = "105.245.36.90/32"
  from_port   = 8080
  to_port     = 8080
  ip_protocol = "tcp"

  tags = {
    Project = "aws-cloud-native-cicd-lab"
  }
}
