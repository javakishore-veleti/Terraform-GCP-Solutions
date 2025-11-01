variable "aws_profile" {
  description = "AWS profile name to use for authentication"
  type        = string
  default     = "terraform-mastery-profile"
}

variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment label used for tagging (e.g., dev, prod)."
  type        = string
  default     = "dev"
}
