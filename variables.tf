# This variable will hold your Google Cloud Project ID.
# We will set its actual value within the Spacelift environment.
variable "gcp_project_id" {
  type        = string
  description = "The GCP project ID to deploy resources into."
}

# This variable will hold the GCP region for your resources.
variable "gcp_region" {
  type        = string
  description = "The GCP region where resources will be created."
  default     = "us-central1" # Setting a default value is often helpful.
}