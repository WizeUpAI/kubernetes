provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_container_cluster" "primary" {
  name                     = "gke-istio-cluster"
  location                 = var.region
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = "default"
  subnetwork = "default"

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  release_channel {
    channel = "REGULAR"
  }

  ip_allocation_policy {}

  addons_config {
    istio_config {
      disabled = false
      auth     = "AUTH_NONE"
    }
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "default-node-pool"
  cluster    = google_container_cluster.primary.name
  location   = var.region
  node_count = 2

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
    labels = {
      workload = "default"
    }
  }
}

resource "google_project_iam_member" "gitlab_ci_identity" {
  role   = "roles/container.admin"
  member = "serviceAccount:${var.gitlab_ci_service_account}"
}

resource "google_project_iam_member" "ci_artifact" {
  role   = "roles/artifactregistry.writer"
  member = "serviceAccount:${var.gitlab_ci_service_account}"
}
