pid_file = "/run/vault/pidfile"

log_level = "trace"

vault {
	address = "https://vault-cluster.vault.11eb56d6-0f95-3a99-a33c-0242ac110007.aws.hashicorp.cloud:8200"
}

auto_auth {
	method "gcp" {
		config = {
			type = "gce"
			role = "nomad-server"
		}
		namespace = "admin"
	}
	sink "file" {
		config = {
						path = "/opt/data/vault/sink"
		}
	}
}

listener "tcp" {
  address       = "127.0.0.1:8200"
  tls_disable = true
}

template {
  contents =<<EOH
[Service]
Environment="VAULT_TOKEN={{ with secret "auth/token/create/nomad" "period=60m" }}{{ .Auth.ClientToken }}{{ end }}"
EOH
  destination="/etc/systemd/system/nomad.service.d/override.conf"
	command="sudo systemctl restart nomad.service"
}