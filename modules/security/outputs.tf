output "gke_sa_email" {
  description = "The email address of the dedicated GKE Service Account"
  value       = google_service_account.sa.email
}