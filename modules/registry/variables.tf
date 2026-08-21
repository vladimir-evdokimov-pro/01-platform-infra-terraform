variable "region" {
  description = "GCP region for deployment"
  type = string
  default = "europe-west9"
}

variable "repository_id_name" {
  description = "The ID of the repository"
  type = string
  default = "order-service-repo"
}

variable "description_repo" {
  description = "Description of the Artifact Registry repository"
  type = string
  default = "Docker repository for order service microservice"
}