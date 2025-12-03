data "aws_availability_zones" "available" {}

locals {
    # Duas primeiras AZs
  azs = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "vpc" {
  source = "../../modulos/vpc"

  name = "it-${var.name}-${var.env}"
  cidr = var.vpc_cidr
  azs  = local.azs
  env  = var.env
  tags = var.tags
}
