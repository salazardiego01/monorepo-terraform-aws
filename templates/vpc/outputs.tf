output "vpc_id" {
  description = "ID da VPC criada"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "Subnets públicas criadas"
  value       = module.vpc.public_subnets
}

output "vpc_cidr_block" {
  description = "CIDR da VPC"
  value       = module.vpc.vpc_cidr_block
}
