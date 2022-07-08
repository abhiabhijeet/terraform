#Creates a GCS (Google Cloud Storage) bucket

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.0"
    }
  }
}

provider "google" {
  project = var.project_id
  credentials = "${file("credential.json")}"
  #project = "eternal-poetry-350701"
  region = "us-central1"
}

variable "project_id" {
  type = string
}

variable "bucket_name_set" {
  description = "A set of GCS bucket names..."
  type    = set(string)
}


resource "google_storage_bucket" "my_bucket_set" {
  project       = "some project id should be here"

  for_each      = toset(var.bucket_name_set)
  name          = each.value     # note: each.key and each.value are the same for a set

  location      = "some region should be here"
  storage_class = "STANDARD"
  force_destroy = true

  uniform_bucket_level_access = true

lifecycle_rule {
    condition {
      age = 3
    }
    action {
      type = "Delete"
    }
  }
}
