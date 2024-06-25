# Terraform
Created a Terraform configuration that launches a VM on GCP’s Compute Engine.
Used the google_compute_instance metadata_startup_script field to install the HTTP server.
The configuration contained a provider block for Google Cloud Platform defined as follows:
provider "google" {
        project     = "<your-GCP-project-ID>"
        region      = "<a-GCP-region>"
        zone        = "<a-GCP-zone>"
}

