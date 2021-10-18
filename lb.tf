resource "google_compute_address" "nomad_ui" {
  name = local.nomad_ui_name
}

resource "google_compute_region_health_check" "nomad_ui" {
  name               = local.nomad_ui_name
  check_interval_sec = 1
  timeout_sec        = 1
  tcp_health_check {
    port_specification = "USE_SERVING_PORT"
  }
}

resource "google_compute_forwarding_rule" "nomad_ui" {
  name            = local.nomad_ui_name
  ip_address      = google_compute_address.nomad_ui.address
  backend_service = google_compute_region_backend_service.nomad_ui.id
  port_range      = var.nomad_ui_port.port
  ip_protocol     = "TCP"
}

resource "google_compute_region_backend_service" "nomad_ui" {
  name = local.nomad_ui_name
	# protocol = "TCP"
	port_name = var.nomad_ui_port.name

  health_checks = [
    google_compute_region_health_check.nomad_ui.id
  ]

	load_balancing_scheme = "EXTERNAL"
  backend {
    group          = google_compute_region_instance_group_manager.server.instance_group
    balancing_mode = "CONNECTION"
  }
}

resource "google_compute_firewall" "nomad_ui" {
  name    = local.nomad_ui_name
  network = google_compute_network.this.name

  source_ranges = var.client_source_ranges

  allow {
    protocol = "tcp"
    ports = [
      var.nomad_ui_port.port
    ]
  }
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
  target_tags = var.nomad_server_tags

  direction = "INGRESS"
}

# bind_addr = "34.116.112.27" #"{{ GetInterfaceIP \"ens4\" }}"
resource "google_compute_firewall" "health_checks" {
  name    = "health-checks"
  network = google_compute_network.this.name

  source_ranges = [
		"35.191.0.0/16",
		"130.211.0.0/22",
		"209.85.152.0/22",
		"209.85.204.0/22"
	]

  allow {
    protocol = "tcp"
		ports = [
      var.nomad_ui_port.port
    ]
  }
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
  target_tags = var.nomad_server_tags

  direction = "INGRESS"
}