provider "aws" {
  region = var.region
}

# Create the application LB to interact with Octopus Deploy from the UI
resource "aws_lb" "lb-od" {
  name     = "octopuslb"
  internet = false
  load_balancer_type = "application"
  security_groups = [ "value" ]

  enable_deletion_protection = true
}

# Create the ECS cluster
resource "aws_ecs_cluster" "ecs-cluster-od" {
  name               = var.ecsClusterName
  capacity_providers = ["FARGATE"]
}

# Create the task definition for ECS to run
resource "aws_ecs_task_definition" "service" {
  family                = "octopus_deploy_server"
  container_definitions = file("task_definition.json")
}

data "aws_ecs_task_definition" "service" {
  task_definition = aws_ecs_task_definition.service.family
}

# Create the ECS task definition service
resource "aws_ecs_service" "ecs-service-od" {
  name          = "octopusdeploy"
  cluster       = aws_ecs_cluster.ecs-cluster-od.id
  desired_count = 2
  load_balancer {
    target_group_arn = aws_lb_target_group.foo.arn
    container_name   = "mongo"
    container_port   = 8080
  }

  task_definition = "${aws_ecs_task_definition.service.family}:${max(aws_ecs_task_definition.service.revision, data.aws_ecs_task_definition.service.revision)}"

}
