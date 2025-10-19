resource "google_project_iam_member" "artifact_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "user:${var.deployer_user_email}"
}

resource "google_project_iam_member" "viewer" {
  project = var.project_id
  role    = "roles/viewer"
  member  = "user:${var.deployer_user_email}"
}
