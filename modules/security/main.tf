resource "google_service_account" "sa" {
  account_id = var.account_id_sa
  display_name = var.display_name_sa
}

resource "google_project_iam_member" "role" {
  for_each = var.role_sa

  project = var.project_id
  member = "serviceAccount:${google_service_account.sa.email}"
  role = each.key
}

resource "google_compute_firewall" "fw_iap" {
  name = var.fw_iap_name
  network = var.vpc_id

  allow {
    protocol = "tcp"
    ports = [ "22" ]
  }

  source_ranges = var.source_ranges

}