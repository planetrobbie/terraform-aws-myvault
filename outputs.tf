# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${module.vpc.vpc_id}"
}

# CIDR blocks
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = ["${module.vpc.vpc_cidr_block}"]
}

# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = ["${module.vpc.private_subnets}"]
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = ["${module.vpc.public_subnets}"]
}

# NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = ["${module.vpc.nat_public_ips}"]
}

# Bastion IP
output "bastion_public_ip" {
  description = "Public IP of Bastion"
  value       = "${aws_instance.bastion.public_ip}"
}

output "vault_instance_ids" {
  value = "${module.vault_cluster.vault_cluster_instance_ids}"
}

output "vault_instance_ips" {
  value = "${module.vault_cluster.vault_cluster_instance_ips}"
}

output "consul_instance_ids" {
  value = "${module.vault_cluster.consul_cluster_instance_ids}"
}

output "consul_instance_ips" {
  value = "${module.vault_cluster.consul_cluster_instance_ips}"
}

output "elb_dns" {
  value = "${module.vault_cluster.elb_dns}"
}

output "info" {
  value = <<END
Bastion Connection: ssh -A ubuntu@${aws_instance.bastion.public_ip}
final script: ./final_config.sh --consul-ips ${join(",", module.vault_cluster.consul_cluster_instance_ips)} --vault-ips ${join(",", module.vault_cluster.vault_cluster_instance_ips)} \
  --kms-region ${var.global_region} \
  --kms-key [Find it in the resources]
END
}
