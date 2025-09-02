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

# Variable for the GCP zone where the VM will be created.
variable "gcp_zone" {
  type        = string
  description = "The GCP zone to create the GCE instance in."
  default     = "us-central1-a"
}

# Variable for the VM's machine type.
variable "gce_machine_type" {
  type        = string
  description = "The machine type for the GCE instance."
  default     = "e2-small"
}

# Variable for the boot disk image.
variable "gce_disk_image" {
  type        = string
  description = "The boot disk image for the GCE instance."
  default     = "debian-cloud/debian-11"
}

# Variable for the name of the service account to be created.
variable "service_account_name" {
  type        = string
  description = "The account_id for the new service account."
  default     = "sl-demo-vm-sa"
}

### ADDED SECTION: Variables for custom VPC ###

# Variable for the name of the custom VPC.
variable "vpc_name" {
  type        = string
  description = "The name of the custom VPC network."
  default     = "spacelift-demo-vpc"
}

# Variable for the IP address range of the subnet.
variable "subnet_cidr" {
  type        = string
  description = "The IP CIDR range for the custom subnet."
  default     = "10.0.1.0/24"
}