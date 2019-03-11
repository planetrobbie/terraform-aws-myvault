variable "global_region" {
  description = "the region vault cluster will be deployed into"
  type        = "string"
}

variable "dns_domain" {
  description = "DNS domain our nodes live in, used in /etc/hosts, important for TLS verif"
  type        = "string"
}

variable "availability_zones" {
  description = "A list AZs the vault cluster will be deployed into"
  type        = "list"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = "string"
}

variable "cluster_name" {
  description = "The name of the Vault cluster (e.g. vault-stage). This variable is used to namespace all resources created by this module."
  type        = "string"
}

variable "public_subnets" {
  description = "A list public subnet cidr blocks"
  type        = "list"
}

variable "private_subnets" {
  description = "A list private subnets the vault cluster will be deployed into"
  type        = "list"
}

variable "instance_type" {
  description = "The type of EC2 Instances to run for each node in the cluster (e.g. t2.micro)."
  type        = "string"
}

variable "ami_id" {
 description = "AMI for Bastion, Vault and Consul instances"
 type        = "string"
}

variable "ssh_key_name" {
  description = "The AWS ssh key to use to build instances in the vault cluster"
  type        = "string"
}

variable "ssh_user" {
  description = "The user used to connect to instances"
  type        = "string"
  default     = "ubuntu"
}

/*------------------------------------------------
Configuration variables to provision a private S3 bucket
------------------------------------------------*/

variable "my_bucket" {
  description = "The S3 bucket for install"
}

/*------------------------------------------------
Configuration variables for demo purpose
------------------------------------------------*/

variable "aws_access_key" {
  description = "AWS Access Key"
}

/*------------------------------------------------
Optional variables that have sensible defaults
------------------------------------------------
Cluster size variables
------------------------------------------------*/
variable "vault_cluster_size" {
  description = "The size (number of instances) in the Vault cluster without an ASG"
  type        = "string"
  default     = 2
}

variable "consul_cluster_size" {
  description = "The size (number of instances) in the consul cluster"
  type        = "string"
  default     = 3
}