resource "aws_route53_zone" "primary" {
  name = "${var.dns_domain}"
}

resource "aws_route53_record" "vault" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name    = "vault.${aws_route53_zone.primary.name}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_elb.vault_lb.dns_name}"]
}

resource "aws_route53_record" "bastion" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name    = "bastion.${aws_route53_zone.primary.name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.bastion.public_ip}"]
}