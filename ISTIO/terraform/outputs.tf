output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "gke_get_credentials" {
  value = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --region ${var.region} --project ${var.project_id}"
}
