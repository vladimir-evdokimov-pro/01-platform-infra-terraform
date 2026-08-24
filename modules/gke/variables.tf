variable "project_id" {
  description = "GCP Project ID"
  type        = string
}
variable "region" {
  description = "GCP region for cluster deployment"
  type        = string
  default     = "europe-west9"
}
variable "gke_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "devsecops-gke-cluster"
}

variable "vpc_id" {
  description = "VPC network ID"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where nodes will be created"
  type        = string
}
variable "pod_range_name" {
  description = "Secondary IP range name dedicated to Pods"
  type        = string
  default     = "gke-pods-range"
}

variable "svc_range_name" {
  description = "Secondary IP range name dedicated to Services"
  type        = string
  default     = "gke-services-range"
}

variable "master_ipv4_cidr_block" {
  description = "IP range for the GKE control plane / master"
  type        = string
  default     = "172.16.0.0/28"
}

variable "node_name" {
  description = "Name of the GKE node pool"
  type        = string
  default     = "devsecops-node-pool"
}
variable "machine_type" {
  description = "Compute Engine machine type for cluster nodes"
  type        = string
  default     = "e2-medium"
}

variable "sa" {
  description = "Email of the dedicated service account for GKE nodes"
  type        = string
}