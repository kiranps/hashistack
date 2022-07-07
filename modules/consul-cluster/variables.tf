# Required Parameters
variable "allowed_inbound_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks to permit inbound Consul access from"
}

variable "name_prefix" {
  type        = string
  description = "prefix used in resource names"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "environment" {
  type        = string
  description = "VPC ID"
}

# Optional Parameters
variable "acl_bootstrap_bool" {
  type        = bool
  default     = false
  description = "Initial ACL Bootstrap configurations"
}

variable "consul_config" {
  type        = map(string)
  default     = {}
  description = "HCL Object with additional configuration overrides supplied to the consul servers.  This is converted to JSON before rendering via the template."
}

variable "consul_join_tag" {
  type        = string
  description = "auto join tag"
}

variable "consul_cluster_version" {
  type        = string
  default     = "0.0.1"
  description = "Custom Version Tag for Upgrade Migrations"
}

variable "consul_servers" {
  type        = number
  default     = "5"
  description = "number of Consul instances"
}

variable "enable_connect" {
  type        = bool
  default     = true
  description = "Whether Consul Connect should be enabled on the cluster"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Instance type for Consul instances"
}

variable "key_name" {
  type        = string
  default     = "default"
  description = "SSH key name for Consul instances"
}

variable "cluster_name" {
  type        = string
}

variable "public_ip" {
  type        = bool
  default     = false
  description = "should ec2 instance have public ip?"
}

variable "ami_id" {
  type        = string
  default     = ""
  description = "EC2 instance AMI ID to override the default Ubuntu AMI"
}

variable "subnet_ids" {
  description = "The subnet IDs into which the EC2 Instances should be deployed. You should typically pass in one subnet ID per node in the cluster_size variable. We strongly recommend that you run Vault in private subnets. At least one of var.subnet_ids or var.availability_zones must be non-empty."
  type        = list(string)
  default     = null
}

variable "consul_version" {
  type        = string
  default     = "1.9.3"
}
