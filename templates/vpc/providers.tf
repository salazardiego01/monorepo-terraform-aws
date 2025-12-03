provider "aws" {
  region  = var.region
  profile = "aws-${var.name}-${var.env}"
}
