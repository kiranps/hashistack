output "server_security_group_id" {
  value = aws_security_group.consul_server.id
}

output "client_security_group_id" {
  value = aws_security_group.consul_client.id
}
