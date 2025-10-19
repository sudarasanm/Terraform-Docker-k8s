module "vpc" {
  source          = "./modules/vpc"
  project_id      = var.project_id
  network_name    = var.network_name
  subnet_ip_cidr  = var.subnet_ip_cidr
  region          = var.region
}

module "gke" {
  source          = "./modules/gke"
  project_id      = var.project_id
  cluster_name    = var.gke_cluster_name
  region          = var.region
  network_name    = module.vpc.network_name
  subnet_name     = module.vpc.subnet_name
}

module "registry" {
  source            = "./modules/registry"
  project_id        = var.project_id
  location          = var.artifact_location
  repository_id     = "docker-repo"
}

module "compute" {
  source               = "./modules/compute"
  project_id           = var.project_id
  zone                 = var.zone
  network_name         = module.vpc.network_name
  subnet_name          = module.vpc.subnet_name
  bastion_machine_type = var.bastion_machine_type
  utility_machine_type = var.utility_machine_type
}

module "iam" {
  source              = "./modules/iam"
  project_id          = var.project_id
  deployer_user_email = var.deployer_user_email
}
