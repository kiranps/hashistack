# data source for availability zones
data "aws_region" "current" {}

resource "aws_autoscaling_group" "consul_servers" {
  name                 = aws_launch_configuration.consul_servers.name
  launch_configuration = aws_launch_configuration.consul_servers.name

  vpc_zone_identifier = var.subnet_ids

  min_size         = var.consul_servers
  max_size         = var.consul_servers
  desired_capacity = var.consul_servers

  wait_for_capacity_timeout = "480s"
  health_check_grace_period = 15
  health_check_type         = "EC2"

  tags = [
    {
      key                 = "Name"
      value               = "${var.cluster_name}-consul-server"
      propagate_at_launch = true
    },
    {
      key                 = "Cluster-Version"
      value               = var.consul_cluster_version
      propagate_at_launch = true
    },
    {
      key                 = "Environment"
      value               = "${var.environment}"
      propagate_at_launch = true
    },
    {
      key                 = "consul_join_tag"
      value               = var.consul_join_tag
      propagate_at_launch = true
    }
  ]

  lifecycle {
    create_before_destroy = true
  }
}

# provides a resource for a new autoscaling group launch configuration
resource "aws_launch_configuration" "consul_servers" {
  name_prefix   = "${var.cluster_name}-consul-servers-${var.consul_cluster_version}"
  image_id      = var.ami_id
  instance_type = var.instance_type

  security_groups = [aws_security_group.consul_server.id, aws_security_group.consul_client.id]

  user_data = templatefile("${path.module}/setup_consul.sh.tpl",
    {
      datacenter       = data.aws_region.current.name,
      bootstrap_expect = var.consul_servers,
      total_nodes      = var.consul_servers,

      consul_version  = var.consul_version,
      consul_join_tag = var.consul_join_tag,

      acl_bootstrap_bool = var.acl_bootstrap_bool,

      consul_cluster_version = var.consul_cluster_version,
      enable_connect         = var.enable_connect,
      consul_config          = var.consul_config,
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
