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


#creating subnet to acheive 2 network interface.
resource "google_compute_network" "vpc_network" {
  name = "network"
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "subnetwork" {
  name          = "subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-east1"
  network       = google_compute_network.vpc_network.name
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
    access_config {  # this won't assign any external ip's to instance
    }
  }
 network_interface {
    subnetwork   = "subnetwork"
  }
}
