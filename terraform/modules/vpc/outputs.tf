output "network_name" {
  description = "The name of the VPC network."
  value       = google_compute_network.main.name
}

output "subnet_name" {
  description = "The name of the subnet."
  value       = google_compute_subnetwork.primary.name
}
