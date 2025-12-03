variable "region" {
  description = "AWS region"
  type        = string
}

variable "name" {
  description = "Prefix for resource naming"
  type        = string
}

variable "azs" {
  description = "Prefix for resource naming"
  type        = list(string)
}

variable "cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "tags" {
  description = "Default resource tags"
  type        = map(string)
}

variable "env" {
  description = "env"
  type = string
}
