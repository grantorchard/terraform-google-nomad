# Provider variables
variable project {
	default = "go-gcp-demos"
}

variable region {
	default = "australia-southeast1"
}

# Network variables
variable vpc_subnet {
	default = "172.16.0.0/16"
}

variable server_subnet {
	default = ""
}

variable client_subnet {
	default = ""
}

# Compute variables
variable server_compute_image_family {
	default = "nomad"
}
variable client_compute_image_family {
	default = "nomad"
}

variable server_machine_type {
	default = "e2-medium"
}

variable client_machine_type {
	default = "e2-medium"
}

variable server_compute_image_project {
	default = ""
}

variable client_compute_image_project {
	default = ""
}

variable nomad_server_tags {
	default = [
		"nomad",
		"server"
	]
}

variable nomad_client_tags {
	default = [
		"nomad",
		"client"
	]
}

variable nomad_ui_port {
	default = {
		name = "nomad-ui"
		port = 4646
	}
	type = object({
		name = string
		port = number
	}
	)
}

variable client_source_ranges {
	default = []
}

# Nomad application variables
variable datacenter_name {
	default = ""
}

variable nomad_data_dir {
	default = "/opt/data/nomad"
}

variable nomad_token_role {
	default = "nomad"
}

# Consul application variables
variable envoy_version {
	type = string
	default = "v1.17.0"
}

variable consul_data_dir {
	default = "/opt/data/consul"
}

# Vault application variables
variable vault_data_dir {
	default = "/opt/data/vault"
}

variable vault_addr {
	type = string
}

variable vault_namespace {
	type = string
	default = ""
}

# Troubleshooting variables

variable enable_ssh {
	default = false
}

variable ssh_key_path {
	default = "~/.ssh/id_rsa.pub"
}

variable ssh_username {
	default = "ubuntu"
}

variable my_public_ips {
	default = []
}