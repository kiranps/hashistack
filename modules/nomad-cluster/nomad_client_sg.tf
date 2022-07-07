resource "aws_security_group" "nomad_client" {
  name        = "${var.cluster_name}-nomad-client-sg"
  description = "Nomad client"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "nomad_client_ingress_rpc" {
  security_group_id        = aws_security_group.nomad_client.id
  type                     = "ingress"
  from_port                = 4647
  to_port                  = 4647
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nomad_server.id
}

resource "aws_security_group_rule" "nomad_client_egress_rpc" {
  security_group_id        = aws_security_group.nomad_client.id
  type                     = "egress"
  from_port                = 4647
  to_port                  = 4647
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nomad_server.id
}

# rule to allow egress from 443 to 443 externally
resource "aws_security_group_rule" "consul_external_egress_https" {
  security_group_id = aws_security_group.nomad_client.id
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# rule to allow egress from 80 to 80 externally
resource "aws_security_group_rule" "consul_external_egress_http" {
  security_group_id = aws_security_group.nomad_client.id
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}
