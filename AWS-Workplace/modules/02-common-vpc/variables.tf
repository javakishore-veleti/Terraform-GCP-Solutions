variable "vpc_name" {
  description = "VPC name."
  type        = string
  default     = "terraform_mastery_vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_private_subnets" {
  description = "Private subnets."
  type        = map(number)
  default     = {
    "private_subnet_1" = 1
    "private_subnet_2" = 2
  }
}

variable "vpc_public_subnets" {
  description = "Public subnets."
  type        = map(number)
  default     = {
    "public_subnet_1" = 1
    "public_subnet_2" = 2
  }
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {
    Terraform   = "true"
    Project     = "Terraform Mastery"
  }
}
