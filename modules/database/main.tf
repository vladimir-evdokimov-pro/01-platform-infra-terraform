resource "random_password" "pwd" {
  length = 32
  special = true
  override_special = "!@#$*%-_+"
}
resource "google_sql_database_instance" "bdd" {
  name = var.bdd_name
  database_version = var.bdd_version
  region = var.region

  settings {
    tier = var.tier

    ip_configuration {
      psc_config {
        psc_enabled = true
        allowed_consumer_projects = [var.project_id]
      }
      ipv4_enabled = false
    }
    availability_type = "REGIONAL"

    backup_configuration {
      enabled = true
      point_in_time_recovery_enabled = true
    }
  }

  deletion_protection = false
}

resource "google_compute_address" "psc_ip" {
  name = var.psc_ip_name
  project = var.project_id
  subnetwork = var.subnet_id
  region = var.region
  address_type = "INTERNAL"
  address = var.psc_ip_address
}

resource "google_compute_forwarding_rule" "fr_psc" {
  name = var.fr_psc_name
  project = var.project_id
  region = var.region
  network = var.vpc_id
  subnetwork = var.subnet_id
  ip_address = google_compute_address.psc_ip.self_link
  target = google_sql_database_instance.bdd.psc_service_attachment_link
  load_balancing_scheme = ""
}

resource "google_sql_database" "db" {
  name = var.db_name
  instance = google_sql_database_instance.bdd.name
}

resource "google_sql_user" "usr" {
  name = var.usr_name
  instance = google_sql_database_instance.bdd.name
  password = random_password.pwd.result
}

