variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
}

variable "zone" {
  description = "GCP Zone"
  type        = string
}

variable "github_username" {
  description = "GitHub username or organization name"
  type        = string
}

variable "gcp_apis" {
  description = "List of APIs to enable for realize this configuration"
  type        = set(string)
  default = [
    "compute.googleapis.com",
    "sqladmin.googleapis.com",
    "secretmanager.googleapis.com",
    "iap.googleapis.com",
    "servicenetworking.googleapis.com",
    "iamcredentials.googleapis.com",
    "iam.googleapis.com",
    "artifactregistry.googleapis.com",
    "container.googleapis.com"
  ]
}