# creates Nomad autoscaling group for clients
resource "aws_autoscaling_group" "nomad_clients" {
  name                 = aws_launch_configuration.nomad_clients.name
  launch_configuration = aws_launch_configuration.nomad_clients.name

  min_size         = var.nomad_clients
  max_size         = var.nomad_clients
  desired_capacity = var.nomad_clients

  wait_for_capacity_timeout = "480s"
  health_check_grace_period = 15
  health_check_type         = "EC2"

  vpc_zone_identifier = var.subnet_ids

  tags = [
    {
      key                 = "Name"
      value               = "${var.cluster_name}-nomad-client"
      propagate_at_launch = true
    },
    {
      key                 = "Cluster-Version"
      value               = var.consul_cluster_version
      propagate_at_launch = true
    },
    {
      key                 = "Environment-Name"
      value               = "${var.environment}"
      propagate_at_launch = true
    }
  ]

  depends_on = [aws_autoscaling_group.nomad_servers]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "nomad_clients" {
  name_prefix   = "nomad-clients-${var.consul_cluster_version}-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  #security_groups = [aws_security_group.nomad_client.id, var.consul_client_security_group_id]

  user_data = templatefile("${path.module}/setup_nomad_client.sh.tpl",
    {
      aws_region      = data.aws_region.current.name,
      consul_version  = var.consul_version,
      nomad_version   = var.nomad_version,
      consul_join_tag = var.consul_join_tag
  })

  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.instance_profile.name

  root_block_device {
    volume_type = "standard"
    volume_size = 8
  }

  lifecycle {
    create_before_destroy = true
  }
}
