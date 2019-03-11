resource "aws_instance" "bastion" {

  ami                         = "${var.ami_id}"
  instance_type               = "${var.instance_type}"
  associate_public_ip_address = true
  key_name                    = "${var.ssh_key_name}"
  vpc_security_group_ids      = ["${aws_security_group.bastion_sg.id}"]
  subnet_id                   = "${module.vpc.public_subnets[0]}"

  tags = {
    Name = "${var.cluster_name}-bastion"
  }
}