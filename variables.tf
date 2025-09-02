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

# ===================================================================
# ==== NEW CODE: Variables for the new resources
# ===================================================================

# This variable will hold the name for our GCE VM instance.
variable "vm_instance_name" {
  type        = string
  description = "The name for the demo GCE VM instance."
  default     = "spacelift-demo-vm"
}

# A VM needs a specific zone (e.g., us-central1-a), not just a region.
variable "gcp_zone" {
  type        = string
  description = "The GCP zone to create the GCE VM in."
  default     = "us-central1-a" # Defaulting to a zone in the default region.
}

# This variable will hold the unique ID for our new service account.
variable "service_account_name" {
  type        = string
  description = "The unique account_id for the new service account."
  default     = "spacelift-demo-sa"
}