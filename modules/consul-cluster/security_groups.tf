resource "aws_security_group" "consul_server" {
  name        = "${var.cluster_name}-consul-server-sg"
  description = "Consul servers"
  vpc_id      = var.vpc_id
}

# rule to allow egress from 443 to 443 externally
resource "aws_security_group_rule" "consul_external_egress_https" {
  security_group_id = aws_security_group.consul_server.id
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# rule to allow egress from 80 to 80 externally
resource "aws_security_group_rule" "consul_external_egress_http" {
  security_group_id = aws_security_group.consul_server.id
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# HTTP
resource "aws_security_group_rule" "consul_ui" {
  count             = length(var.allowed_inbound_cidr_blocks) >= 1 ? 1 : 0
  security_group_id = aws_security_group.consul_server.id
  type              = "ingress"
  from_port         = 8500
  to_port           = 8500
  protocol          = "tcp"
  cidr_blocks       = var.allowed_inbound_cidr_blocks
}

# RPC
resource "aws_security_group_rule" "consul_rpc" {
  type                     = "ingress"
  from_port                = 8300
  to_port                  = 8300
  protocol                 = "tcp"
  security_group_id        = aws_security_group.consul_server.id
  source_security_group_id = aws_security_group.consul_client.id
}
