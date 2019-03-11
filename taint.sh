terraform taint aws_instance.bastion
terraform taint -module=vault_cluster aws_instance.vault-instance.0
terraform taint -module=vault_cluster aws_instance.vault-instance.1
terraform taint -module=vault_cluster aws_instance.consul-instance.0
terraform taint -module=vault_cluster aws_instance.consul-instance.1
terraform taint -module=vault_cluster aws_instance.consul-instance.2
