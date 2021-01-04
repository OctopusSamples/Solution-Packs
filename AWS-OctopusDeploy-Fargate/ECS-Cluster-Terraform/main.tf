provider "aws" {
  region  = var.region
}

resource "aws_ecs_cluster" "ecs-cluster-od" {
    name = var.ecsClusterName
    capacity_providers = [ "FARGATE" ]
}