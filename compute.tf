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
  # metadata_startup_script = templatefile("${path.module}/templates/server.hcl.tpl", {
  #   boundary_version               = var.boundary_version
  #   ca_name                        = var.tls_disabled == true ? null : google_privateca_certificate_authority.this[0].certificate_authority_id
	# 	ca_issuer_location             = var.tls_disabled == true ? null : var.ca_issuer_location
  #   server_api_listener_ip     = google_compute_address.public_server_api.address
  #   server_cluster_listener_ip = google_compute_address.public_server_cluster.address
  #   server_api_port            = var.server_api_port
  #   server_cluster_port        = var.server_cluster_port
  #   project_id                     = var.project
  #   public_cluster_address         = google_compute_address.public_server_cluster.address
  #   db_endpoint                    = google_sql_database_instance.this.private_ip_address
  #   db_name                        = google_sql_database.this.name
  #   db_username                    = var.boundary_database_username
  #   db_password                    = var.boundary_database_password
  #   tls_disabled                   = var.tls_disabled
  #   tls_key_path                   = var.tls_disabled == true ? null : var.tls_key_path
  #   tls_cert_path                  = var.tls_disabled == true ? null : var.tls_cert_path
  #   kms_key_ring                   = google_kms_key_ring.this.name
  #   kms_worker_auth_key_id         = google_kms_crypto_key.worker_auth.name
  #   kms_recovery_key_id            = google_kms_crypto_key.recovery.name
  #   kms_root_key_id                = google_kms_crypto_key.root.name
  # })
  lifecycle {
    create_before_destroy = true
  }
}