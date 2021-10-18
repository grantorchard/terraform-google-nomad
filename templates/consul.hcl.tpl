datacenter = "{{ hashicorp_datacenter }}"
data_dir  = "{{ consul_data_dir }}"
encrypt = "gwYVEJdMIRYTziCzBtBYcHn2o5d9xh1OpnHAYkGkJKI="
server = false
bind_addr = {% raw %}"{{ GetInterfaceIP \"ens192\" }}"{% endraw %}

{% if consul_connect == true }
connect {
	enabled = true
}
{% endif }

ports {
	grpc = 8502
}

enable_central_service_config = true
log_level = "INFO"

retry_join = [
      "provider=vsphere category_name=hashi tag_name=consul host=hlcorevc01.humblelab.com user=administrator@vsphere.local password=VMware123! insecure_ssl=true"
]

