provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "vpc" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=v6.5.1"

  name = var.name
  cidr = var.cidr

  # Apenas 2 subnets públicas
  azs            = var.azs
  public_subnets = [
    cidrsubnet(var.cidr, 8, 0),
    cidrsubnet(var.cidr, 8, 1),
  ]

  # Garantir IGW e route table pública
  manage_default_security_group = false
  manage_default_network_acl    = false
  manage_default_route_table    = true

  enable_nat_gateway = false
  create_igw         = true

  public_subnet_names = [
    "${var.name}-public-1-${var.env}",
    "${var.name}-public-2-${var.env}",
  ]

  tags = var.tags
}
