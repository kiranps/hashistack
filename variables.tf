variable "aws_region" {
  description = ""
  type        = string
  default     = "ap-south-1"
}

variable "environment" {
  description = ""
  type        = string
  default     = "testing-hashi"
}

variable "vault_cluster_name" {
  description = "What to name the Vault server cluster and all of its associated resources"
  type        = string
  default     = "vault-dynamo-example"
}

variable "ami_id" {
  type        = string
  default     = "ami-075f86791fd5c25c0"
}

variable "vault_cluster_size" {
  description = "The number of Vault server nodes to deploy. We strongly recommend using 3 or 5."
  type        = number
  default     = 1
}

variable "vault_instance_type" {
  description = "The type of EC2 Instance to run in the Vault ASG"
  type        = string
  default     = "t2.micro"
}

variable "dynamo_table_name" {
  description = "The name of the Dynamo Table to create and use as a storage backend. Only used if 'enable_dynamo_backend' is set to true."
  default     = "my-vault-table"
}
