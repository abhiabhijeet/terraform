# Summary: Uses the 'count' feature to create multiple disks attached to multiple VM instances (with google_compute_attached_disk)

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.0"
    }
  }
}

variable "project_id" {
  type = string
}

provider "google" {
  project = var.project_id
  region  = "us-central1"
  zone    = "us-central1-a"
}

variable "changeme_google_attached_disk_count_number_of_instances" {
  type    = number
  default = 3
}

# Attach disks to instances
resource "google_compute_attached_disk" "changeme_count_attached_disk" {
  # Documentation: https://www.terraform.io/docs/language/meta-arguments/count.html
  count    = var.count_instances
  disk     = google_compute_disk.count_disk[count.index].id
  instance = google_compute_instance.count_instance[count.index].id
}

# Compute Instances
resource "google_compute_instance" "count_instance" {
  name         = "attached-disk-instance-${count.index}"
  count        = var.count_instances
  machine_type = "f1-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    # Explanation: A default network is created for all GCP projects
    network = "default"
    access_config {
    }
  }
}

# Persistent disks
resource "google_compute_disk" "attached_disk_disk" {
  name                      = "attached-disk-disk-${count.index}"
  count                     = var.count_instances
  type                      = "pd-ssd"
  zone                      = "us-central1-a"
  size                      = 4
  physical_block_size_bytes = 4096
}
