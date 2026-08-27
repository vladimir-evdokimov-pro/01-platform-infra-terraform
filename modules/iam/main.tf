resource "google_service_account" "wif_sa" {
  account_id   = var.wif_sa_name
  display_name = var.wif_sa_display_name
}

resource "google_project_iam_member" "member_sa" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.wif_sa.email}"
}

resource "google_iam_workload_identity_pool" "pool" {
  workload_identity_pool_id = var.pool_id
  display_name              = var.pool_display_name
  description               = "Workload Identity Pool for GitHub Actions CI/CD"
}

resource "google_iam_workload_identity_pool_provider" "pool_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.pool.workload_identity_pool_id
  workload_identity_pool_provider_id = var.pool_provider_id
  display_name                       = "GitHub Actions Provider"

  attribute_condition = "assertion.repository_owner == '${var.github_username}'"

  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.actor"            = "assertion.actor"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account_iam_binding" "binding_sa" {
  service_account_id = google_service_account.wif_sa.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.pool.name}/attribute.repository_owner/${var.github_username}"
  ]
}