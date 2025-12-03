terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket         = "seu mucket"        # ALTERE
    key            = "vpc/terraform.tfstate"  # Caminho separado por ambiente
    region         = "us-west-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }
}
