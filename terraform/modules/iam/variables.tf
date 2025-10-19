variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "deployer_user_email" {
  description = "The email of the user to grant IAM roles."
  type        = string
}
