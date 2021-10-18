data "google_compute_image" "server" {
  family  = var.server_compute_image_family
  project = var.server_compute_image_project != "" ? var.server_compute_image_project : null
}

data "google_compute_image" "client" {
  family  = var.client_compute_image_family
  project = var.client_compute_image_project != "" ? var.client_compute_image_project : null
}


resource "google_compute_instance_template" "server" {
  name_prefix    = local.nomad_server_name
  machine_type   = var.server_machine_type
  can_ip_forward = var.enable_ssh

  disk {
    source_image = data.google_compute_image.server.id
  }

  network_interface {
    subnetwork = google_compute_subnetwork.server.id
    dynamic "access_config" {
      for_each = var.enable_ssh == true ? [0] : []
      content {}
    }
  }

  service_account {
    email  = google_service_account.nomad_server.email
    scopes = ["cloud-platform"]
  }

  tags = var.nomad_server_tags

  metadata = {
    ssh-keys = local.ssh_key_string
  }
  metadata_startup_script = templatefile("${path.module}/templates/startup_script.tpl", {
		nomad_config = templatefile("${path.module}/templates/nomad.hcl.tpl", {
			role = "server"
			datacenter = var.datacenter_name != "" ? var.datacenter_name : var.project
			project = var.project
			nomad_data_dir = var.nomad_data_dir
			nomad_server_tags = join(",", var.nomad_server_tags)
			vault_addr = var.vault_addr
			vault_namespace = var.vault_namespace != "" ? var.vault_namespace : null
			nomad_token_role = var.nomad_token_role
			envoy_version = var.envoy_version
		}),
		vault_config = templatefile("${path.module}/templates/vault.hcl.tpl", {})
	})

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_group_manager" "server" {
  name = local.nomad_server_name

	named_port {
		name = var.nomad_ui_port.name
		port = var.nomad_ui_port.port
	}

  version {
    instance_template = google_compute_instance_template.server.id
    #name              = var.boundary_version
  }

  base_instance_name = local.nomad_server_name
}

resource "google_compute_region_autoscaler" "server" {
  name   = local.nomad_server_name
  target = google_compute_region_instance_group_manager.server.id

  autoscaling_policy {
    max_replicas    = 1
    min_replicas    = 1
    cooldown_period = 60
  }
}

resource "google_compute_firewall" "ssh" {
  count   = var.enable_ssh == true ? 1 : 0
  name    = "${local.nomad_name}-ssh-access"
  network = google_compute_network.this.name

  source_ranges = var.my_public_ips

  allow {
    protocol = "tcp"
    ports = [
      22
    ]
  }
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
  target_tags = concat(var.nomad_server_tags, var.nomad_client_tags)

  direction = "INGRESS"
}