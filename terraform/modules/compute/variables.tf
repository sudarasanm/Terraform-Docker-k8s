variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "zone" {
  description = "The GCP zone."
  type        = string
}

variable "network_name" {
  description = "The name of the VPC network."
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet."
  type        = string
}

variable "bastion_machine_type" {
  description = "The machine type for the bastion VM."
  type        = string
}

variable "utility_machine_type" {
  description = "The machine type for the utility VM."
  type        = string
}
