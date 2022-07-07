resource "aws_security_group" "nomad_server" {
  name        = "${var.cluster_name}-nomad-server-sg"
  description = "Nomad servers"
  vpc_id      = var.vpc_id
}

# rule to allow egress from 443 to 443 externally
resource "aws_security_group_rule" "nomad_external_egress_https" {
  security_group_id = aws_security_group.nomad_server.id
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# rule to allow egress from 80 to 80 externally
resource "aws_security_group_rule" "nomad_external_egress_http" {
  security_group_id = aws_security_group.nomad_server.id
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# HTTP API
resource "aws_security_group_rule" "nomad_api_tcp" {
  security_group_id        = aws_security_group.nomad_server.id
  type                     = "ingress"
  from_port                = 4646
  to_port                  = 4646
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nomad_server.id
}

resource "aws_security_group_rule" "nomad_api_ingress" {
  security_group_id = aws_security_group.nomad_server.id
  type              = "ingress"
  from_port         = 4646
  to_port           = 4646
  protocol          = "tcp"
  cidr_blocks       = var.allowed_inbound_cidr_blocks
}

#RPC
resource "aws_security_group_rule" "nomad_ingress_rpc" {
  security_group_id        = aws_security_group.nomad_server.id
  type                     = "ingress"
  from_port                = 4647
  to_port                  = 4647
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nomad_server.id
}

resource "aws_security_group_rule" "nomad_egress_rpc" {
  security_group_id        = aws_security_group.nomad_server.id
  type                     = "egress"
  from_port                = 4647
  to_port                  = 4647
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nomad_server.id
}

resource "aws_security_group_rule" "nomad_ingress_rpc_client" {
  security_group_id        = aws_security_group.nomad_server.id
  type                     = "ingress"
  from_port                = 4647
  to_port                  = 4647
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nomad_client.id
}

resource "aws_security_group_rule" "nomad_egress_rpc_client" {
  security_group_id        = aws_security_group.nomad_server.id
  type                     = "egress"
  from_port                = 4647
  to_port                  = 4647
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nomad_client.id
}

# Serf
resource "aws_security_group_rule" "nomad_tcp_ingress_serf" {
  security_group_id        = aws_security_group.nomad_server.id
  type                     = "ingress"
  from_port                = 4648
  to_port                  = 4648
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nomad_server.id
}

resource "aws_security_group_rule" "nomad_tcp_egress_serf" {
  security_group_id        = aws_security_group.nomad_server.id
  type                     = "egress"
  from_port                = 4648
  to_port                  = 4648
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nomad_server.id
}

resource "aws_security_group_rule" "nomad_udp_ingress_serf" {
  security_group_id        = aws_security_group.nomad_server.id
  type                     = "ingress"
  from_port                = 4648
  to_port                  = 4648
  protocol                 = "udp"
  source_security_group_id = aws_security_group.nomad_server.id
}

resource "aws_security_group_rule" "nomad_udp_egress_serf" {
  security_group_id        = aws_security_group.nomad_server.id
  type                     = "egress"
  from_port                = 4648
  to_port                  = 4648
  protocol                 = "udp"
  source_security_group_id = aws_security_group.nomad_server.id
}
