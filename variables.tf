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
	default = []
}

variable nomad_client_tags {
	default = []
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