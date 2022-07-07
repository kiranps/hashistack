resource "aws_security_group" "consul_client" {
  name        = "${var.cluster_name}-consul-client-sg"
  description = "Consul client"
  vpc_id      = var.vpc_id
}

# RPC

resource "aws_security_group_rule" "consul_rpc_egress_tcp" {
  security_group_id        = aws_security_group.consul_client.id
  type                     = "egress"
  from_port                = 8300
  to_port                  = 8300
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.consul_server.id
  description              = "consul rpc"
}

# Serf

resource "aws_security_group_rule" "consul_serf_egress_udp" {
  security_group_id = aws_security_group.consul_client.id
  type              = "egress"
  from_port         = 8301
  to_port           = 8301
  protocol          = "udp"
  self              = true
  description       = "consul serf lan"
}

resource "aws_security_group_rule" "consul_serf_egress_tcp" {
  security_group_id = aws_security_group.consul_client.id
  type              = "egress"
  from_port         = 8301
  to_port           = 8301
  protocol          = "tcp"
  self              = true
  description       = "consul serf lan"
}

resource "aws_security_group_rule" "consul_serf_udp" {
  security_group_id = aws_security_group.consul_client.id
  type              = "ingress"
  from_port         = 8301
  to_port           = 8301
  protocol          = "udp"
  self              = true
  description       = "consul serf lan"
}

resource "aws_security_group_rule" "consul_serf_tcp" {
  security_group_id = aws_security_group.consul_client.id
  type              = "ingress"
  from_port         = 8301
  to_port           = 8301
  protocol          = "tcp"
  self              = true
  description       = "consul serf lan"
}
