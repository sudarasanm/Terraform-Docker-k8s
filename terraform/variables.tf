variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "region" {
  description = "The GCP region."
  type        = string
  default     = "asia-south1"
}

variable "zone" {
  description = "The GCP zone."
  type        = string
  default     = "asia-south1-a"
}

variable "network_name" {
  description = "The name of the VPC network."
  type        = string
  default     = "wobot-vpc"
}

variable "subnet_ip_cidr" {
  description = "The IP CIDR range for the subnet."
  type        = string
  default     = "10.10.0.0/16"
}

variable "gke_cluster_name" {
  description = "The name of the GKE cluster."
  type        = string
  default     = "wobot-gke"
}

variable "artifact_location" {
  description = "The location for the Artifact Registry repository."
  type        = string
  default     = "asia-south1"
}

variable "bastion_machine_type" {
  description = "The machine type for the bastion VM."
  type        = string
  default     = "e2-micro"
}

variable "utility_machine_type" {
  description = "The machine type for the utility VM."
  type        = string
  default     = "e2-small"
}

variable "deployer_user_email" {
  description = "The email of the user to grant IAM roles."
  type        = string
  default     = "<YOUR_EMAIL>"
}
