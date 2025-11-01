output "aws_region" {
  value       = var.aws_region
  description = "Region used for deployments."
}

output "environment" {
  value       = var.environment
  description = "Current environment label."
}

output "available_azs" {
  value       = data.aws_availability_zones.available.names
  description = "Available AZs in this region."
}
