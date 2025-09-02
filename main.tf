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
resource "google_storage_bucket" "example_bucket" {
  # This is the globally unique name for the storage bucket.
  name          = "my-unique-spacelift-demo-bucket-12345" # CHANGE THIS to a unique name
  location      = var.gcp_region
  force_destroy = true # This allows us to easily delete the bucket later

  # Labels are key-value pairs that help you organize your GCP resources.
  labels = {
    managed-by = "spacelift"
    purpose    = "integration-demo"
  }
}

# This resource block creates a new Service Account in your GCP project.
resource "google_service_account" "vm_service_account" {
  # This is the unique ID for the service account within your project.
  account_id   = var.service_account_name
  # This is a user-friendly name that will appear in the GCP Console.
  display_name = "Service Account for Spacelift Demo VM"
}


### ADDED SECTION: Create a custom VPC Network ###

# Creates a new Virtual Private Cloud (VPC) network.
# auto_create_subnetworks = false is best practice for custom control.
resource "google_compute_network" "custom_vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}


### ADDED SECTION: Create a Subnet within the custom VPC ###

# Creates a subnet in the region defined by our provider.
# It depends on the VPC created above.
resource "google_compute_subnetwork" "custom_subnet" {
  name          = "spacelift-demo-subnet"
  ip_cidr_range = var.subnet_cidr
  region        = var.gcp_region
  network       = google_compute_network.custom_vpc.id
}


### ADDED SECTION: Create a Firewall Rule to allow SSH ###

# Creates a firewall rule to allow ingress traffic on TCP port 22 (SSH).
# Without this, you will not be able to connect to your VM.
resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.vpc_name}-allow-ssh"
  network = google_compute_network.custom_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "3389"]
  }

  # This allows SSH traffic from any IP address. For production, you might want
  # to restrict this to specific IP ranges (e.g., your office network).
    source_ranges = ["35.235.240.0/20"]
}


### MODIFIED SECTION: Create a GCE VM in the custom VPC ###

# This resource block creates a new GCE virtual machine.
resource "google_compute_instance" "default_vm" {
  # The name for the VM instance.
  name         = "spacelift-demo-vm"
  # The machine type (e.g., e2-medium, n1-standard-1).
  machine_type = var.gce_machine_type
  # The zone where the VM will be created (e.g., us-central1-a).
  zone         = var.gcp_zone

  # The boot disk configuration for the VM.
  boot_disk {
    initialize_params {
      # The operating system image to use for the boot disk.
      image = var.gce_disk_image
    }
  }

  # The network configuration for the VM.
  # This section is MODIFIED to use our new custom subnet instead of "default".
  network_interface {
    subnetwork = google_compute_subnetwork.custom_subnet.id
    # An empty access_config block assigns an ephemeral public IP address.
    access_config {}
  }

  # This section attaches the Service Account created above to this VM.
  service_account {
    email  = google_service_account.vm_service_account.email
    scopes = ["cloud-platform"]
  }

  # Labels to help organize the VM.
  labels = {
    managed-by = "spacelift"
    purpose    = "integration-demo"
  }
}