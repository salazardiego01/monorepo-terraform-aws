variable "region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "eu-west-1"
}

variable "vpc_cidr" {
  description = "CIDR for main VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "tags" {
  description = "Tag map to apply to all resources"
  type        = map(string)
  default     = {
    Project = "projeto1"
    Env     = "dev"
  }
}
variable "env" {
  description = "env"
  type = string
}

variable "name" {
  description = "Nome do projeto / prefixo dos recursos"
  type        = string
  default = "name"
}