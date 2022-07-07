#!/bin/bash 

sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install consul-${consul_version} vault-${vault_version}

function create_vault_config_file {
sudo cat << EOF > /etc/vault.d/vault.hcl
ui = true

api_addr = "http://127.0.0.1:8200"

listener "tcp" {
  address            = "0.0.0.0:8200"
  tls_disable        = 1
}

storage "dynamodb" {
  ha_enabled = "true"
  region     = "${aws_region}"
  table      = "${dynamodb_table_name}"
}

seal "awskms" {
  region     = "${aws_region}"
  kms_key_id = "${kms_key_arn}"
}

service_registration "consul" {
  address      = "127.0.0.1:8500"
}
EOF

  sudo chown -R vault:vault /etc/vault.d
}

function create_consul_client_config_file {

LOCAL_IPV4=`curl -s http://169.254.169.254/latest/meta-data/local-ipv4`

cat << EOF > /etc/consul.d/consul.hcl
datacenter          = "${aws_region}"
server              = false
data_dir            = "/opt/consul/data"
advertise_addr      = "$${LOCAL_IPV4}"
client_addr         = "0.0.0.0"
log_level           = "INFO"
ui                  = true

# AWS cloud join
retry_join          = ["provider=aws tag_key=consul_join_tag tag_value=${consul_join_tag}"]

EOF
}

function start_vault_service {
  sudo systemctl daemon-reload
  sudo systemctl enable vault.service
  sudo systemctl start vault.service
}

function start_consul_service {
  sudo systemctl daemon-reload
  sudo systemctl enable consul.service
  sudo systemctl start consul.service
}

create_vault_config_file
create_consul_client_config_file
start_vault_service
start_consul_service
