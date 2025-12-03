provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2" # exemplo

  name = var.name
  cidr = var.vpc_cidr

  # Apenas 2 subnets públicas
  azs            = local.azs
  public_subnets = [
    cidrsubnet(var.vpc_cidr, 8, 0),
    cidrsubnet(var.vpc_cidr, 8, 1),
  ]

  # Garantir IGW e route table pública
  manage_default_security_group = false
  manage_default_network_acl    = false
  manage_default_route_table    = true

  enable_nat_gateway = false
  create_igw         = true

  public_subnet_names = [
    "${var.name}-public-1",
    "${var.name}-public-2",
  ]

  tags = var.tags
}
