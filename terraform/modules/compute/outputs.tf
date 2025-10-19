output "bastion_external_ip" {
  description = "The external IP of the bastion VM."
  value       = google_compute_instance.bastion.network_interface[0].access_config[0].nat_ip
}
