provider "aws" {
  region  = var.region
}

resource "aws_ecs_task_definition" "service" {
  family                = "octopus_deploy_server"
  container_definitions = file("task_definition.json")
}