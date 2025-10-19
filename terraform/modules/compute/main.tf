resource "google_compute_instance" "bastion" {
  project      = var.project_id
  zone         = var.zone
  name         = "bastion-vm"
  machine_type = var.bastion_machine_type
  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-12"
    }
  }
  network_interface {
    network    = var.network_name
    subnetwork = var.subnet_name
    access_config {}
  }
  metadata = {
    enable-oslogin = "TRUE"
  }
}

resource "google_compute_instance" "utility" {
  project      = var.project_id
  zone         = var.zone
  name         = "utility-vm"
  machine_type = var.utility_machine_type
  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-12"
    }
  }
  network_interface {
    network    = var.network_name
    subnetwork = var.subnet_name
  }
  metadata = {
    enable-oslogin = "TRUE"
  }
}
