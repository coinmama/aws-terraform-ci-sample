provider "aws" {
  region = var.region
}

resource "random_pet" "service_name" {}

locals {
  aws_tags = { "service" : random_pet.service_name.id, "environment" : "test" }
  subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24", "10.0.7.0/24", "10.0.8.0/24"]
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.0.0"

  name = "test.ec2.vpc"
  # Consider moving from Internet Gateway to NAT Gateway?
  cidr               = "10.0.0.0/16"
  azs                = data.aws_availability_zones.available.names
  public_subnets     = slice(local.subnets, 0, length(data.aws_availability_zones.available.names))
  single_nat_gateway = true
  tags               = local.aws_tags
}
