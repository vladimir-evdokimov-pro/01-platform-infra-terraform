output "workload_identity_pool_provider" {
  description = "Full WIF Provider resource URI for GitHub Actions"
  value       = google_iam_workload_identity_pool_provider.pool_provider.name
}

output "service_account_mail" {
  description = "Email address of the created Service Account"
  value       = google_service_account.wif_sa.email
}
