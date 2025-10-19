variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "location" {
  description = "The location for the Artifact Registry repository."
  type        = string
}

variable "repository_id" {
  description = "The ID of the Artifact Registry repository."
  type        = string
}
