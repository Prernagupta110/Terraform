terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.84.0"
    }
  }
}
provider "google" {
  credentials = file("credentials.json")

  project = "css-prerna-2023-399612"
  region  = "europe-central2"
  zone    = "europe-central2-a"
}

resource "google_compute_network" "vpc_network" {
  name    = "terraform-network"
  project = "css-prerna-2023-399612"
}

resource "google_compute_instance" "vm_instance" {
  name         = var.vm_name_input
  machine_type = "f1-micro"
  zone         = "europe-central2-a"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
  tags = ["http-server"]
  labels = {
    course = "css-gcp"
  }
  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    systemctl start apache2
    systemctl enable apache2
  EOF  

}
resource "google_compute_firewall" "firewall" {
  name    = "allow-http"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_tags   = ["http-server"]
  source_ranges = ["0.0.0.0/0"]
}

variable "vm_name_input" {
  default = "vm-terraform"
  type    = string
}

output "vm_name" {
  value = google_compute_instance.vm_instance.name

}
output "public_ip" {
  value = google_compute_instance.vm_instance.network_interface.0.access_config.0.nat_ip
}
