provider aws {
  region     = "${var.global_region}"
  version    = "~> 1.50"
}

module vpc {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc"

  name = "${var.vpc_name}"

  cidr = "10.0.0.0/16"

  azs             = "${var.availability_zones}"
  private_subnets = "${var.private_subnets}"
  public_subnets  = "${var.public_subnets}"

  assign_generated_ipv6_cidr_block = false

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    Name = "public_sn"
  }

  tags = {
    usecase     = "vault"
    Terraform   = "true"
    Environment = "dev"
    Owner       = "SE Team"
  }

  vpc_tags = {
    Name = "sebastien_vpc"
  }

}

resource "aws_security_group" "bastion_sg" {
  description = "Enable SSH access to the bastion via SSH port"
  name        = "bastion-security-group"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# SG for private instances
resource "aws_security_group" "private_instances_sg" {
  description = "Enable SSH access to the Private instances from the bastion via SSH port"
  name        = "private-security-group"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port = 22
    protocol  = "TCP"
    to_port   = 22

    security_groups = [
      "${aws_security_group.bastion_sg.id}",
    ]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
