module "vault_cluster" {
  source = "./modules/vault-cluster"

  environment  = "testing"
  cluster_name = "testing-vault"
  cluster_size = 1

  ami_id        = var.ami_id
  instance_type = "t2.micro"

  vpc_id     = aws_vpc.vpc.id
  subnet_ids = [aws_subnet.public_subnet.id]

  allowed_inbound_cidr_blocks           = ["0.0.0.0/0"]
  consul_client_security_group_id = module.consul_cluster.client_security_group_id

  dynamo_table_name = "my-vault-table"
  consul_join_tag   = "consul-testing"
}

module "consul_cluster" {
  source = "./modules/consul-cluster"

  environment    = "testing"
  cluster_name   = "consult-testing"
  consul_servers = 3

  ami_id        = var.ami_id
  instance_type = "t2.micro"

  name_prefix = "testing"

  vpc_id                      = aws_vpc.vpc.id
  subnet_ids                  = [aws_subnet.public_subnet.id]
  allowed_inbound_cidr_blocks = ["0.0.0.0/0"]

  consul_join_tag = "consul-testing"
}

module "nomad_cluster" {
  source = "./modules/nomad-cluster"

  environment    = "testing"
  cluster_name   = "consult-testing"
  nomad_servers = 3
  nomad_clients = 1

  ami_id        = var.ami_id
  instance_type = "t2.micro"

  name_prefix = "testing"

  vpc_id                      = aws_vpc.vpc.id
  subnet_ids                  = [aws_subnet.public_subnet.id]
  allowed_inbound_cidr_blocks = ["0.0.0.0/0"]
  consul_client_security_group_id = module.consul_cluster.client_security_group_id

  consul_join_tag = "consul-testing"
}
