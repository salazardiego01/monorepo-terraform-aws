variable "region" {
  description = "AWS region"
  type        = string
}

variable "name" {
  description = "Prefix for resource naming"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "tags" {
  description = "Default resource tags"
  type        = map(string)
  default     = {}
}
