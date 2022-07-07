# data source for current (working) aws region
data "aws_region" "current" {}

# creates Nomad autoscaling group for servers
resource "aws_autoscaling_group" "nomad_servers" {
  name                 = aws_launch_configuration.nomad_servers.name
  launch_configuration = aws_launch_configuration.nomad_servers.name

  min_size         = var.nomad_servers
  max_size         = var.nomad_servers
  desired_capacity = var.nomad_servers

  wait_for_capacity_timeout = "480s"
  health_check_grace_period = 15
  health_check_type         = "EC2"

  vpc_zone_identifier = var.subnet_ids

  tags = [
    {
      key                 = "Name"
      value               = "${var.cluster_name}-nomad-server"
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

  lifecycle {
    create_before_destroy = true
  }
}

# provides a resource for a new autoscaling group launch configuration
resource "aws_launch_configuration" "nomad_servers" {
  name_prefix   = "nomad-servers-${var.consul_cluster_version}-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  security_groups = [aws_security_group.nomad_server.id, var.consul_client_security_group_id]

  user_data = templatefile("${path.module}/setup_nomad_server.sh.tpl",
    {
      aws_region       = data.aws_region.current.name
      bootstrap_expect = var.nomad_servers
      total_nodes      = var.nomad_servers
      consul_join_tag  = var.consul_join_tag
      consul_version  = var.consul_version
      nomad_version   = var.nomad_version
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
