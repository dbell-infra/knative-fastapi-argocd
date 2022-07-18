resource "aws_route53_zone" "k8s" {
  name = "k8s.${var.hosted_zone}"

  tags = {
    Environment = "dev"
  }
}

resource "aws_route53_zone" "apps" {
  name = "apps.${var.hosted_zone}"

  tags = {
    Environment = "dev"
  }
}

resource "aws_route53_record" "dev-ns" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "k8s.${var.hosted_zone}"
  type    = "NS"
  ttl     = "30"
  records = aws_route53_zone.k8s.name_servers
}

resource "aws_route53_record" "apps-ns" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "apps.${var.hosted_zone}"
  type    = "NS"
  ttl     = "30"
  records = aws_route53_zone.apps.name_servers
}