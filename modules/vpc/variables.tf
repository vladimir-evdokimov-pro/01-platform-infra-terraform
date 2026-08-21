variable "region" {
  description = "GCP region for deployment"
  type = string
  default = "europe_west9"
}

variable "vpc_name" {
  description = "Name of the main VPC network"
  type = string
  default = "devsecops-vpc"
}

variable "subnet_name" {
  description = "Name of the main subnet for nodes"
  type = string
  default = "devsecops-gke-subnet"
}

variable "subnet_cidr" {
  description = "IP range for GKE nodes (4,096 IPs)"
  type = string
  default = "10.0.0.0/20"
}

variable "pod_range_name" {
  description = "Name of the secondary IP range for Pods"
  type = string
  default = "gke-pods-range"
}

variable "pod_cidr" {
  description = "IP range for Pods (65,536 IPs)"
  type = string
  default = "10.1.0.0/16"
}

variable "svc_range_name" {
  description = "Name of the secondary IP range for Services"
  type = string
  default = "gke-services-range"
}

variable "svc_cidr" {
  description = "IP range for Services (4,096 IPs)"
  type = string
  default = "10.2.0.0/20"
}

variable "router_name" {
  description = "Name of the Cloud Router"
  type = string
  default = "devsecops-vpc-router"
}

variable "nat_name" {
  description = "Name of the Cloud NAT gateway"
  type = string
  default = "devsecops-vpc-nat"
}