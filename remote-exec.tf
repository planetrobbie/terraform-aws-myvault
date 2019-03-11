data "template_file" "bastion_config" {
  template = "${file("./files/bastion_config.sh")}"

  vars {
    v1              = "${module.vault_cluster.vault_cluster_instance_ips[0]}"
    ssh_user        = "${var.ssh_user}"

  }
}
# Ansible Inventory
data "template_file" "hosts" {
  template = "${file("./files/hosts")}"

  vars {
    v1              = "${module.vault_cluster.vault_cluster_instance_ips[0]}"
    v2              = "${module.vault_cluster.vault_cluster_instance_ips[1]}"
    c1              = "${module.vault_cluster.consul_cluster_instance_ips[0]}"
    c2              = "${module.vault_cluster.consul_cluster_instance_ips[1]}"
    c3              = "${module.vault_cluster.consul_cluster_instance_ips[2]}"
  }
}

# /etc/hosts template
data "template_file" "etc_hosts" {
  template = "${file("./files/etc_hosts")}"

  vars {
    b               = "${aws_instance.bastion.public_ip}"
    v1              = "${module.vault_cluster.vault_cluster_instance_ips[0]}"
    v2              = "${module.vault_cluster.vault_cluster_instance_ips[1]}"
    c1              = "${module.vault_cluster.consul_cluster_instance_ips[0]}"
    c2              = "${module.vault_cluster.consul_cluster_instance_ips[1]}"
    c3              = "${module.vault_cluster.consul_cluster_instance_ips[2]}"
    dns_domain      = "${var.dns_domain}"
  }
}

data "template_file" "playbook" {
  template = "${file("./files/playbook.yml")}"

  vars {
    ssh_user       = "${var.ssh_user}"
    dns_domain     = "${var.dns_domain}"
    v1             = "${module.vault_cluster.vault_cluster_instance_ips[0]}"
  }
}

# Pet cheatsheet commands snippets
data "template_file" "snippet" {
  template = "${file("./files/snippet.tpl")}"
  vars {
    global_region      = "${var.global_region}"
    aws_access_key     = "${var.aws_access_key}"
    vault_address      = "https://vault.${var.dns_domain}:8200"
    consul_ips         = "${join(",", module.vault_cluster.consul_cluster_instance_ips)}"
    vault_ips          = "${join(",", module.vault_cluster.vault_cluster_instance_ips)}"
    dynamo_table_name  = "${var.owner}-vault-demo-beers"
    dynamo_read_policy = "${aws_iam_policy.dynamodb_beers_read.arn}"
  }
}

# Target Bastion Host
resource "null_resource" "remote-exec" {
  triggers {
    version = 3,
    bastion_config = "${data.template_file.bastion_config.rendered}",
    hosts = "${data.template_file.hosts.rendered}",
    etc_hosts = "${data.template_file.etc_hosts.rendered}",
    final_config = "./files/final_config.sh",
    playbook = "${data.template_file.bastion_config.rendered}",
    snippets = "${data.template_file.snippet.rendered}",
    ansible_cfg = "./files/ansible.cfg",
  }

  connection {
    type = "ssh"
    host = "${aws_instance.bastion.public_ip}"
    user = "${var.ssh_user}"
    private_key = "${file("./files/priv_key")}"
  }

  // copy final_config.sh script
  provisioner "file" {
    source      = "./files/final_config.sh"
    destination = "/home/${var.ssh_user}/final_config.sh"
  }

  // copy bastion_config.sh script which contains operations before we have ansible ready
  provisioner "file" {
    content      = "${data.template_file.bastion_config.rendered}"
    destination = "/home/${var.ssh_user}/bastion_config.sh"
  }

  // copy ansible inventory
  provisioner "file" {
    content      = "${data.template_file.hosts.rendered}"
    destination = "/home/${var.ssh_user}/hosts"
  }

  // copy ansible inventory
  provisioner "file" {
    content      = "${data.template_file.etc_hosts.rendered}"
    destination = "/home/${var.ssh_user}/etc_hosts"
  }

  // copy playbook
  provisioner "file" {
    content      = "${data.template_file.playbook.rendered}"
    destination = "/home/${var.ssh_user}/playbook.yml"
  }
 
  // copy our Pet Snippets over
  provisioner "file" {
    content      = "${data.template_file.snippet.rendered}"
    destination = "/tmp/snippet.toml"
  }

  // copy Ansible configuration
  provisioner "file" {
    source      = "./files/ansible.cfg"
    destination = "/home/${var.ssh_user}/ansible.cfg"
  }

  // change permissions to executable 
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.ssh_user}/final_config.sh",
      "chmod +x /home/${var.ssh_user}/bastion_config.sh",
      "/home/${var.ssh_user}/bastion_config.sh > /tmp/bastion_config",
    ]
  }
}