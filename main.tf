data "aws_subnets" "confidential_subnets" {

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
  # us-east-1a (use1-az4)
  # subnet-7bcae326 us-east-1b (use1-az6)
  tags = {
    Name = "*Confidential*"
  }

}


data "aws_subnet" "confidential_subnet" {
  for_each = toset(data.aws_subnets.confidential_subnets.ids)
  id       = each.value
}

data "aws_vpc" "default_vpc" {
  filter {
    name   = "tag:aws:cloudformation:logical-id"
    values = ["VPC"]
  }
}


resource "aws_ecs_cluster" "patchinventory_ecs_cluster" {
  name = "patchinventory"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = var.tags

}

resource "aws_ecs_cluster_capacity_providers" "patchinventory_ecs_cluster_capacity_providers" {
  cluster_name = aws_ecs_cluster.patchinventory_ecs_cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }

}


