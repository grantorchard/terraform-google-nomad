sudo snap install yq

interface_name=$(cat /etc/netplan/50-cloud-init.yaml | yq eval '.network.ethernets.[].set-name' -)

cat <<EOF > /etc/vault.d/vault.hcl
${vault_config}
EOF

cat <<EOF > /etc/nomad.d/nomad.hcl
${nomad_config}
EOF

sudo systemctl daemon-reload
sudo systemctl restart vault.service
