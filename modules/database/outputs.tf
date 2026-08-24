output "db_instance_connection_name" {
  description = "Connection name of the Cloud SQL instance for GKE Proxy / PSC"
  value = google_sql_database_instance.bdd.connection_name
}

output "db_private_ip" {
  description = "Private IP address of the Cloud SQL instance"
  value = google_compute_address.psc_ip.address
}

output "db_name" {
  description = "Name of the PostgreSQL database"
  value = google_sql_database.db.name
}

output "db_user" {
  description = "Database username"
  value = google_sql_user.usr.name
}

output "db_password" {
  description = "Generated database password"
  value = random_password.pwd.result
  sensitive = true
}