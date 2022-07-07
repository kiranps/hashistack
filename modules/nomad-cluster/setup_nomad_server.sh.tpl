#!/usr/bin/env bash

sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install consul-${consul_version} nomad-${nomad_version}

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

function create_nomad_server_config_file {
cat << EOF > /etc/nomad.d/nomad.hcl
data_dir = "/opt/nomad/data"
bind_addr = "0.0.0.0"

# Enable the server
server {
  enabled = true
  bootstrap_expect = ${bootstrap_expect}
}

consul {
  address = "127.0.0.1:8500"
}
EOF

chown -R nomad:nomad /etc/nomad.d
chmod -R 640 /etc/nomad.d/*
}

function start_nomad_server {
  sudo systemctl daemon-reload
  sudo systemctl enable nomad
  sudo systemctl start nomad
}

function start_consul_client {
  sudo systemctl daemon-reload
  sudo systemctl enable consul
  sudo systemctl start consul
}

create_consul_client_config_file
create_nomad_server_config_file
start_consul_client
start_nomad_server
