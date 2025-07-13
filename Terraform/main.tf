provider "google" {
  project = var.project_id
  region  = var.region
}

module "gke" {
  source     = "./modules/gke"
  project_id = var.project_id
  region     = var.region
  cluster_name = var.cluster_name
}

module "monitoring" {
  source       = "./modules/monitoring"
  project_id   = var.project_id
  region       = var.region
  cluster_name = var.cluster_name
}