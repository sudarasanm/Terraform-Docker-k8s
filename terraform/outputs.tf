output "gke_name" {
  description = "The name of the GKE cluster."
  value       = module.gke.cluster_name
}

output "gke_endpoint" {
  description = "The endpoint of the GKE cluster."
  value       = module.gke.cluster_endpoint
}

output "artifact_repo" {
  description = "The Artifact Registry repository."
  value       = module.registry.repository_url
}

