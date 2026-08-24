variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region for Cloud SQL deployment"
  type        = string
  default     = "europe-west9"
}

variable "vpc_id" {
  description = "VPC self-link or network ID for private connectivity"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for Private Service Connect endpoint"
  type        = string
}

variable "bdd_name" {
  description = "Name of the Cloud SQL instance"
  type        = string
  default     = "devsecops-db-instance"
}

variable "bdd_version" {
  description = "Database engine version"
  type        = string
  default     = "POSTGRES_18"
}

variable "tier" {
  description = "Machine tier for the Cloud SQL instance"
  type        = string
  default     = "db-f1-micro"
}

variable "psc_ip_name" {
  description = "Name of the static internal IP for PSC"
  type        = string
  default     = "sql-psc-ip"
}

variable "psc_ip_address" {
  description = "Name of the PSC forwarding rule"
  type        = string
  default     = null
}

variable "fr_psc_name" {
  description = "Name of the PSC forwarding rule"
  type        = string
  default     = "sql-psc-endpoint"
}

variable "db_name" {
  description = "Name of the default PostgreSQL database"
  type        = string
  default     = "order_db"
}

variable "usr_name" {
  description = "Username for database access"
  type        = string
  default     = "order_user"
}