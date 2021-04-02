resource "google_compute_network" "this" {
  name                    = local.nomad_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "server" {
  name          = local.nomad_server_name
  ip_cidr_range = var.server_subnet == "" ? cidrsubnet(var.vpc_subnet, 5, 0) : var.server_subnet
  network       = google_compute_network.this.id
}

resource "google_compute_subnetwork" "client" {
  name          = local.nomad_client_name
  ip_cidr_range = var.client_subnet == "" ? cidrsubnet(var.vpc_subnet, 5, 1) : var.client_subnet
  network       = google_compute_network.this.id
}