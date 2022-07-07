data "aws_region" "current" {}

resource "aws_kms_key" "unseal_key" {
  description = "The master key used to unseal vault in automation"
  key_usage   = "ENCRYPT_DECRYPT"
  is_enabled  = true
}

resource "aws_kms_alias" "unseal_key_alias" {
  name          = "alias/${var.cluster_name}-unseal-key"
  target_key_id = aws_kms_key.unseal_key.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "vault_servers" {
  name_prefix = "${var.cluster_name}-"

  launch_configuration = aws_launch_configuration.vault_servers.name

  availability_zones  = var.availability_zones
  vpc_zone_identifier = var.subnet_ids

  min_size         = var.cluster_size
  max_size         = var.cluster_size
  desired_capacity = var.cluster_size

  termination_policies      = [var.termination_policies]
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  wait_for_capacity_timeout = var.wait_for_capacity_timeout

  enabled_metrics = var.enabled_metrics

  depends_on = [aws_dynamodb_table.vault_dynamo]

  tag {
    key                 = var.cluster_tag_key
    value               = var.cluster_name
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.cluster_extra_tags

    content {
      key                 = tag.value.key
      value               = tag.value.value
      propagate_at_launch = tag.value.propagate_at_launch
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [load_balancers, target_group_arns]
  }
}

resource "aws_launch_configuration" "vault_servers" {
  name_prefix   = "${var.cluster_name}-vault-server"
  image_id      = var.ami_id
  instance_type = var.instance_type

  user_data = templatefile("${path.module}/setup_vault.sh.tpl", {
    aws_region          = data.aws_region.current.name
    dynamodb_table_name = var.dynamo_table_name
    kms_key_arn         = aws_kms_key.unseal_key.arn
    consul_join_tag     = var.consul_join_tag
    consul_version      = var.consul_version
    vault_version       = var.vault_version
  })

  iam_instance_profile = aws_iam_instance_profile.instance_profile.name

  security_groups = [aws_security_group.lc_security_group.id, var.consul_client_security_group_id]

  placement_tenancy           = var.tenancy
  associate_public_ip_address = true
  ebs_optimized               = var.root_volume_ebs_optimized

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    delete_on_termination = var.root_volume_delete_on_termination
  }

  lifecycle {
    create_before_destroy = true
  }
}
