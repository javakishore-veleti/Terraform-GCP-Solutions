terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.38.0"
    }
  }
}

# Path to your GCP credentials and config JSONs
variable "gcp_key_path" {
  description = "Path to GCP service account key"
  type        = string
  default     = "~/.gcp/terraform-gcp-key.json"
}

variable "project_info_path" {
  description = "Path to JSON file containing project information"
  type        = string
  default     = "~/.gcp/my_gcp_project_info.json"
}

# Read and decode JSON file
locals {
  project_info = jsondecode(file(var.project_info_path))
}

provider "google" {
  credentials = file(var.gcp_key_path)
  project     = local.project_info.project_id
  region      = local.project_info.region
  zone        = local.project_info.zone
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "google_storage_bucket" "GCS_Bucket" {
  name                        = "bucket-from-tf-with-service-account--${random_id.suffix.hex}"
  location                    = local.project_info.region
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition { age = 30 }
    action    { type = "Delete" }
  }

  labels = {
    environment = "dev"
    managed_by  = "terraform"
  }
}

output "bucket_name" {
  description = "The name of the GCS bucket"
  value       = google_storage_bucket.GCS_Bucket.name
}