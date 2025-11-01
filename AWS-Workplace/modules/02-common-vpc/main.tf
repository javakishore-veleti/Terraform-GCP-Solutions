# Import base configuration (provider, region, etc.)
module "common" {
  source = "../01-common-configs"
}

# Retrieve region + AZs for use in resources
data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name        = var.vpc_name
    Environment = module.common.environment
  })
}

# Private subnets
resource "aws_subnet" "private" {
  for_each = var.vpc_private_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone = tolist(module.common.available_azs)[each.value]

  tags = merge(var.tags, {
    Name = "${var.vpc_name}_private_${each.key}"
  })
}

# Public subnets
resource "aws_subnet" "public" {
  for_each = var.vpc_public_subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, each.value + length(var.vpc_private_subnets))
  availability_zone       = tolist(module.common.available_azs)[each.value]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.vpc_name}_public_${each.key}"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "${var.vpc_name}_igw" })
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]
  tags       = merge(var.tags, { Name = "${var.vpc_name}_nat_eip" })
}

# NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public["public_subnet_1"].id
  depends_on    = [aws_eip.nat_eip]
  tags          = merge(var.tags, { Name = "${var.vpc_name}_nat" })
}

# Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(var.tags, { Name = "${var.vpc_name}_public_rtb" })
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = merge(var.tags, { Name = "${var.vpc_name}_private_rtb" })
}

# Route table associations
resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}
