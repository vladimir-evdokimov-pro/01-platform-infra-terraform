output "vpc_id" {
  description = "value"
  value = google_compute_network.vpc.id
}

output "vpc_name" {
  description = "value"
  value = google_compute_network.vpc.name
}

output "subnet_id" {
  description = "value"
  value = google_compute_subnetwork.subnet.id
}

output "subnet_name" {
  description = "value"
  value = google_compute_subnetwork.subnet.name
}

output "pod_range_name" {
  description = "value"
  value = var.pod_range_name
}

output "svc_range_name" {
  description = "value"
  value = var.svc_range_name
}