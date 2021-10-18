datacenter = "${datacenter}"

data_dir  = "${nomad_data_dir}"

bind_addr = "{{ GetInterfaceIP \"$interface_name\" }}"

ports {
  http = 4646
  rpc  = 4647
  serf = 4648
}

%{ if role == "server" }
server {
  enabled          = true
  bootstrap_expect = 3
}
%{ endif }

consul {
  address = "127.0.0.1:8500"
}

vault {
  enabled   = true
  address   = "${vault_addr}"
	%{ if can(vault_namespace) }namespace = "${vault_namespace}"%{ endif }
	%{ if role == "server" }create_from_role = "${nomad_token_role}"%{ endif }
}

%{ if role == "client" }
meta {
	"connect.sidecar_image" = "envoyproxy/envoy:${envoy_version}"
}
client {
	enabled = true
	options {
		"docker.privileged.enabled" = "true"
		"driver.raw_exec.enable" = "1"
	}
}
%{ endif }

retry_join = [
	"provider=gce project_name=${project} tag_value=${nomad_server_tags}"
]