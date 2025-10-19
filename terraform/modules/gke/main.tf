resource "google_container_cluster" "primary" {
  project                  = var.project_id
  name                     = var.cluster_name
  location                 = var.region
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = var.network_name
  subnetwork               = var.subnet_name
  deletion_protection      = false

  ip_allocation_policy {}

  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }

  private_cluster_config {
    enable_private_nodes = false
  }

  node_config {
    disk_size_gb = 50
  }
}

resource "google_container_node_pool" "primary_nodes" {
  project    = var.project_id
  name       = "${var.cluster_name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    disk_size_gb = 50
    machine_type = "e2-standard-2"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
