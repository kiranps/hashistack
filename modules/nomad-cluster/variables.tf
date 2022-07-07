variable "allowed_inbound_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks to permit inbound Nomad access from"
}

variable "bootstrap" {
  type        = bool
  default     = true
  description = "Initial Bootstrap configurations"
}

variable "nomad_clients" {
  default     = "3"
  description = "number of Nomad instances"
}

variable "consul_config" {
  description = "HCL Object with additional configuration overrides supplied to the consul servers.  This is converted to JSON before rendering via the template."
  default     = {}
}

variable "consul_cluster_version" {
  default     = "0.0.2"
  description = "Custom Version Tag for Upgrade Migrations"
}

variable "nomad_servers" {
  default     = "5"
  description = "number of Nomad instances"
}

variable "enable_connect" {
  type        = bool
  description = "Whether Consul Connect should be enabled on the cluster"
  default     = false
}

variable "instance_type" {
  default     = "t2.micro"
  description = "Instance type for Consul instances"
}

variable "key_name" {
  default     = "default"
  description = "SSH key name for Consul instances"
}

variable "name_prefix" {
  description = "prefix used in resource names"
}


variable "public_ip" {
  type        = bool
  default     = false
  description = "should ec2 instance have public ip?"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "consul_join_tag" {
  type        = string
  description = "auto join tag"
}

variable "ami_id" {
  description = "The ID of the AMI to run in this cluster. Should be an AMI that had Vault installed and configured by the install-vault module."
}

variable "environment" {
  type        = string
  description = "VPC ID"
}

variable "subnet_ids" {
  description = "The subnet IDs into which the EC2 Instances should be deployed. You should typically pass in one subnet ID per node in the cluster_size variable. We strongly recommend that you run Vault in private subnets. At least one of var.subnet_ids or var.availability_zones must be non-empty."
  type        = list(string)
  default     = null
}

variable "cluster_name" {
  description = "The name of the Vault cluster (e.g. vault-stage). This variable is used to namespace all resources created by this module."
}

variable "consul_client_security_group_id" {
  type        = string
  description = "consul_cluster_serf_security_group_id"
}

variable "consul_version" {
  type        = string
  default     = "1.9.3"
}

variable "nomad_version" {
  type        = string
  default     = "1.0.1"
}
