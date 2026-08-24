resource "google_project_service" "apis" {
  for_each = var.gcp_apis

  project            = var.project_id
  service            = each.key
  disable_on_destroy = false
}

module "network" {
  source = "./modules/vpc"

  depends_on = [google_project_service.apis]
}

module "registry" {
  source = "./modules/registry"
  region = var.region

  depends_on = [google_project_service.apis]
}

module "security" {
  source = "./modules/security"

  project_id = var.project_id
  vpc_id     = module.network.vpc_id

  depends_on = [ google_project_service.apis ]
}

module "gke" {
  source = "./modules/gke"

  project_id = var.project_id
  region     = var.region
  vpc_id     = module.network.vpc_id
  subnet_id  = module.network.subnet_id
  sa         = module.security.gke_sa_email

  depends_on = [ google_project_service.apis ]
}

module "database" {
  source = "./modules/database"

  project_id = var.project_id
  region     = var.region
  vpc_id     = module.network.vpc_id
  subnet_id  = module.network.subnet_id

  depends_on = [ google_project_service.apis ]
}