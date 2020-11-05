provider "aws" {
  region = var.region
}

locals {
  aws_tags       = { "service" : "myservice", "environment" : "dev" }
  container_port = var.svc_internal_port == 0 ? var.svc_port : var.svc_internal_port
}

