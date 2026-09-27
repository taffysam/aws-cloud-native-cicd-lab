# Terraform Infrastructure

This directory contains the AWS infrastructure for the shipping API lab.

Terraform manages the ECS cluster, task definition, networking,
IAM roles, CloudWatch logs, and ECR repository.

GitHub Actions manages application image publishing and ECS deployments.

The ECS service normally runs with desired_count = 0 to control lab costs.
