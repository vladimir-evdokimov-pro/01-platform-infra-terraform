output "repository_id" {
  description = "The ID of the repository"
  value = google_artifact_registry_repository.repo.id
}

output "repository_id_name" {
  description = "The full name of the repository"
  value = google_artifact_registry_repository.repo.name
}