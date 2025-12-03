output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "public_route_table_ids" {
  description = "Route table IDs for public subnets"
  value       = module.vpc.public_route_table_ids
}

output "igw_id" {
  description = "Internet Gateway ID"
  value       = module.vpc.igw_id
}
