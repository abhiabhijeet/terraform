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

#creating 2 SLES 12 instance with two 2 Network interface
resource "google_compute_instance" "sles12" {
  count = "2"
  name         = "terraform-${count.index+1}"
  machine_type = "e2-medium"
  zone         = "us-east1-b"

  boot_disk {
    initialize_params {
      image = "suse-cloud/sles-12"
      size= 200
    }
  }

  network_interface {
    subnetwork   = "default"
    access_config {
    }
  }
 network_interface {
    subnetwork   = "subnetwork"
  }
}
