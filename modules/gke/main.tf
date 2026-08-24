resource "google_container_cluster" "gke" {
  name = var.gke_name
  location = var.region

  network = var.vpc_id
  subnetwork = var.subnet_id

  ip_allocation_policy {
    cluster_secondary_range_name = var.pod_range_name
    services_secondary_range_name = var.svc_range_name
  }

  private_cluster_config {
    enable_private_nodes = true
    enable_private_endpoint = false
    master_ipv4_cidr_block = var.master_ipv4_cidr_block
  }

  remove_default_node_pool = true

  initial_node_count = 1

  deletion_protection = false
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

resource "google_container_node_pool" "node" {
  name = var.node_name
  location = var.region

  cluster = google_container_cluster.gke.name

  node_count = 1

  node_config {
    machine_type = var.machine_type
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    service_account = var.sa
  }
}