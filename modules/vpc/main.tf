resource "google_compute_network" "vpc" {
  name = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name = var.subnet_name

  network = google_compute_network.vpc.id
  region = var.region
  ip_cidr_range = var.subnet_cidr

  private_ip_google_access = true

  secondary_ip_range {
    range_name = var.pod_range_name
    ip_cidr_range = var.pod_cidr
  }

  secondary_ip_range {
    range_name = var.svc_range_name
    ip_cidr_range = var.svc_cidr
  }
}

resource "google_compute_router" "router" {
  name = var.router_name
  network = google_compute_network.vpc.name
  region = var.region
}

resource "google_compute_router_nat" "nat" {
  name = var.nat_name

  router = google_compute_network.router.name
  region = var.region
  
  nat_ip_allocate_option = "AUTO_ONLY"

  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}