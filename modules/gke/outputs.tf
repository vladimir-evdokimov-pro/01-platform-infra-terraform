output "cluster_name" {
  description = "The name of the GKE cluster"
  value       = google_container_cluster.gke.name
}

output "cluster_endpoint" {
  description = "The IP address of the GKE cluster master control plane"
  value       = google_container_cluster.gke.endpoint
}

output "ca_certificates" {
  description = "The public CA certificate required to authenticate to the cluster"
  value       = google_container_cluster.gke.master_auth[0].cluster_ca_certificate
  sensitive   = true
}
