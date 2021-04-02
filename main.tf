provider google {
	project = var.project
	region = var.region
}
provider random {}

resource "random_string" "this" {
	length = 8
	special = false
	upper = false
}

locals {
	nomad_name = "nomad-${random_string.this.result}"
	nomad_server_name = "nomad-server-${random_string.this.result}"
	nomad_client_name = "nomad-client-${random_string.this.result}"
}

