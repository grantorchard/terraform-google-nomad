### Service Account creation for Google Compute Instances
resource "random_string" "nomad_server" {
  upper   = false
  special = false
  number  = false
  length  = 16
}

resource "random_string" "nomad_client" {
  upper   = false
  special = false
  number  = false
  length  = 16
}

resource "google_service_account" "nomad_server" {
  account_id   = random_string.nomad_server.result
  display_name = local.nomad_server_name
}


resource "google_service_account" "nomad_client" {
  account_id   = random_string.nomad_client.result
  display_name = local.nomad_client_name
}


### IAM for tag discovery - used for cloud join
resource "google_project_iam_custom_role" "this" {
  role_id     = "nomadTagRead"
  title       = "Nomad Compute Tag Read"
  permissions = [
		"compute.zones.list",
	]
}

resource "google_project_iam_binding" "this" {
  project = var.project
  role    = google_project_iam_custom_role.this.name
  members  = [
      "serviceAccount:${google_service_account.nomad_server.email}",
      "serviceAccount:${google_service_account.nomad_client.email}"
    ]
}
