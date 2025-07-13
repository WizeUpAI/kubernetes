variable "project_id" {
  description = "Your GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "europe-west1"
}

variable "gitlab_ci_service_account" {
  description = "GitLab CI/CD Workload Identity service account email (e.g. gitlab-ci@my-project.iam.gserviceaccount.com)"
  type        = string
}
