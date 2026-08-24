variable "project_id" {
  description = "GCP Project ID"
  type = string
}

variable "vpc_id" {
  description = "VPC network ID or name where firewall rules apply"
  type = string
}

variable "account_id_sa" {
  description = "Account ID for the GKE nodes service account"
  type = string
  default = "gke-nodes-sa"
}

variable "display_name_sa" {
  description = "Display name for the GKE nodes service account"
  type = string
  default = "Service Account for GKE Nodes"
}

variable "role_sa" {
  description = "Set of IAM roles assigned to the GKE nodes service account"
  type = set(string)
  default = [ 
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/artifactregistry.reader"
  ]
}

variable "fw_iap_name" {
  description = "Name of the firewall rule for IAP SSH access"
  type = string
  default = "fw-allow-iap"
}

variable "source_ranges" {
  description = "Allowed IP ranges for IAP SSH access"
  type = list(string)
  default = [ 
    "35.191.0.0/16",
    "130.211.0.0/22"
  ]
}