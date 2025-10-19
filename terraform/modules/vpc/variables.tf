variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "network_name" {
  description = "The name of the VPC network."
  type        = string
}

variable "subnet_ip_cidr" {
  description = "The IP CIDR range for the subnet."
  type        = string
}

variable "region" {
  description = "The GCP region."
  type        = string
}
