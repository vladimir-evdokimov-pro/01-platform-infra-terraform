variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "github_username" {
  description = "GitHub username or organization name"
  type        = string
}

variable "wif_sa_name" {
  description = "Technical ID for the Service Account"
  type        = string
  default     = "github-actions-sa"
}

variable "wif_sa_display_name" {
  description = "Display name in the GCP Console"
  type        = string
  default     = "GitHub Actions Service Account"
}

variable "pool_id" {
  description = "Workload Identity Pool ID"
  type        = string
  default     = "github-actions-pool"
}

variable "pool_display_name" {
  description = "Display name for the WIF Pool"
  type        = string
  default     = "GitHub Actions Pool"
}

variable "pool_provider_id" {
  description = "Workload Identity Provider ID"
  type        = string
  default     = "github-actions-provider"
}

