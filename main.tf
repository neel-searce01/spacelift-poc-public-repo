# This block tells Terraform we are going to be working with Google Cloud Platform.
# The "version" argument is a good practice to ensure your code works with a
# specific version of the GCP provider.
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# This block configures the Google Cloud provider.
# Spacelift will automatically provide a temporary access token as an environment
# variable (GOOGLE_OAUTH_ACCESS_TOKEN). The Terraform provider is smart enough
# to automatically detect and use this token for authentication, so we don't
# need to specify any credentials here.
provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

# This is an example resource block. It tells Terraform to create a
# Google Cloud Storage bucket.
# "google_storage_bucket" is the resource type.
# "example_bucket" is the local name we give this resource inside our Terraform code.
resource "google_storage_bucket" "example_bucket" {
  # This is the globally unique name for the storage bucket.
  # IMPORTANT: You must change this name to something unique!
  name          = "my-unique-spacelift-demo-bucket-98765" 
  location      = var.gcp_region
  force_destroy = true # This allows us to easily delete the bucket later

  # Labels are key-value pairs that help you organize your GCP resources.
  labels = {
    managed-by = "spacelift"
    purpose    = "integration-demo"
  }
}

# ===================================================================
# ==== NEW CODE: Create a basic GCP Service Account
# ===================================================================
# The "google_service_account" resource type creates a new service account.
# This is a non-human identity that applications (like our VM) can use to
# authenticate with other Google Cloud services.
resource "google_service_account" "example_sa" {
  # The account_id is a unique identifier for the service account within your project.
  account_id   = var.service_account_name
  # The display_name is a user-friendly name shown in the GCP Console.
  display_name = "Demo Service Account for GCE VM"
}

# ===================================================================
# ==== NEW CODE: Create a basic GCE Virtual Machine
# ===================================================================
# The "google_compute_instance" resource type creates a new virtual machine.
resource "google_compute_instance" "example_vm" {
  # The name of the VM instance.
  name         = var.vm_instance_name
  # The machine type (e.g., e2-micro is a small, inexpensive option).
  machine_type = "e2-micro"
  # A VM must be created in a specific "zone" within a region (e.g., us-central1-a).
  zone         = var.gcp_zone

  # This block defines the boot disk for the VM.
  boot_disk {
    initialize_params {
      # This specifies the operating system image to use for the boot disk.
      # Here, we are using a standard Debian 11 image from Google.
      image = "debian-cloud/debian-11"
    }
  }

  # This block defines the network interface for the VM.
  # We are attaching it to the "default" network, which exists in every GCP project.
  network_interface {
    network = "default"
  }

  # This block attaches the service account we created above to this VM.
  # This allows applications running on the VM to use the identity of the service account.
  service_account {
    # We reference the email of the service account created in the previous block.
    # Terraform automatically understands this dependency.
    email  = google_service_account.example_sa.email
    scopes = ["cloud-platform"]
  }

  # Labels for organization.
  labels = {
    managed-by = "spacelift"
    purpose    = "integration-demo"
  }
}