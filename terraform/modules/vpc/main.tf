resource "google_compute_network" "main" {
  project                 = var.project_id
  name                    = var.network_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "primary" {
  project                  = var.project_id
  name                     = "${var.network_name}-subnet"
  ip_cidr_range            = var.subnet_ip_cidr
  region                   = var.region
  network                  = google_compute_network.main.id
  private_ip_google_access = true
}

resource "google_compute_firewall" "allow_iap_ssh" {
  project       = var.project_id
  name          = "${var.network_name}-allow-iap-ssh"
  network       = google_compute_network.main.name
  direction     = "INGRESS"
  source_ranges = ["35.235.240.0/20"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
