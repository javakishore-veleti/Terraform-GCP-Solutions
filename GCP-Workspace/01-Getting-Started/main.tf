terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.38.0"
    }
  }
}

variable "gcp_project_id" {
  type = string
  default = "terraform-gcp"
}

variable "gcp_region" {
    type = string
    default = "us-central1"
}

variable "gcp_zone" {
    type = string
    default = "us-central1-a"
}

provider "google" {
  project = "${var.gcp_project_id}"
  region = "${var.gcp_region}"
  zone = "${var.gcp_zone}"
}