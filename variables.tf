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


# Troubleshooting variables

variable enable_ssh {
	default = false
}

variable ssh_key_path {
	default = "~/.ssh/id_rsa.pub"
}

variable ssh_user {
	default = "ubuntu"
}