/*------------------------------------------------------------------------------
This is the configuration for Vault ELB. 
------------------------------------------------------------------------------*/
resource "aws_elb" "vault_lb" {
  name                        = "vault"
  cross_zone_load_balancing   = true
  idle_timeout                = 60
  connection_draining         = true
  connection_draining_timeout = 300
  subnets                     = ["${module.vpc.public_subnets}"]
  security_groups             = ["${aws_security_group.elb_inbound.id}", "${data.aws_security_group.vault_cluster_int.id}"]
  instances                   = ["${module.vault_cluster.vault_cluster_instance_ids}"]

  listener {
    lb_port            = 8200
    lb_protocol        = "TCP"
    instance_port      = 8200
    instance_protocol  = "TCP"
  }

  health_check {
    target              = "HTTPS:8200/v1/sys/health"
    interval            = 15
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }
}

/*------------------------------------------------------------------------------
This is the configuration for Consul ELB. 8500 listening only on 127.0.0.1 :(
will use ngrok !
------------------------------------------------------------------------------*/
#resource "aws_elb" "consul_lb" {
#  name                        = "consul"
#  cross_zone_load_balancing   = true
#  idle_timeout                = 60
#  connection_draining         = true
#  connection_draining_timeout = 300
#  subnets                     = ["${module.vpc.public_subnets}"]
#  security_groups             = ["${aws_security_group.elb_inbound.id}", "${data.aws_security_group.vault_cluster_int.id}"]
#  instances                   = ["${module.vault_cluster.consul_cluster_instance_ids}"]
#
#  listener {
#    lb_port            = 8500
#    lb_protocol        = "TCP"
#    instance_port      = 8500
#    instance_protocol  = "TCP"
#  }
#
#  health_check {
#    target              = "HTTP:8500/"
#    interval            = 15
#    healthy_threshold   = 2
#    unhealthy_threshold = 2
#    timeout             = 5
#  }
#}

/*--------------------------------------------------------------
LB inbound Security Group
--------------------------------------------------------------*/

resource "aws_security_group" "elb_inbound" {
  name        = "elb_inbound"
  description = "ELB inbound traffic"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

#  ingress {
#    from_port   = 8500
#    to_port     = 8500
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
}

data "aws_security_group" "vault_cluster_int" {
  name = "vault_cluster_int"
}