output "gcp_workload_identity_provider" {
  value = module.wif.workload_identity_pool_provider
}

output "gcp_service_account_email" {
  value = module.wif.service_account_mail
}
output "cluster_name" {
  description = "The name of the created GKE cluster"
  value       = module.gke.cluster_name
}

output "cluster_endpoint" {
  description = "The IP address of the GKE control plane"
  value       = module.gke.cluster_endpoint
}

output "ca_certificates" {
  description = "The root CA certificate for GKE authentication"
  value       = module.gke.ca_certificates
  sensitive   = true
}

output "gke_sa_email" {
  description = "The email of the dedicated Service Account for GKE nodes"
  value       = module.security.gke_sa_email
}

output "db_private_ip" {
  description = "The PSC endpoint IP address for database connections"
  value       = module.database.db_private_ip
}

output "db_instance_connection_name" {
  description = "The Cloud SQL connection name for proxy access"
  value       = module.database.db_instance_connection_name
}

output "db_name" {
  description = "The name of the PostgreSQL database"
  value       = module.database.db_name
}

output "db_user" {
  description = "The primary database username"
  value       = module.database.db_user
}

output "db_password" {
  description = "The auto-generated password for the database user"
  value       = module.database.db_password
  sensitive   = true
}