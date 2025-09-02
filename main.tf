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
  name          = "my-unique-spacelift-demo-bucket-12345" # CHANGE THIS to a unique name
  location      = var.gcp_region
  force_destroy = true # This allows us to easily delete the bucket later

  # Labels are key-value pairs that help you organize your GCP resources.
  labels = {
    managed-by = "spacelift"
    purpose    = "integration-demo"
  }
}