resource "aws_route53_record" "main" {
  zone_id = data.aws_route53_zone.main.id
  name    = "${var.name}.dan.cash"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_lb.main.dns_name]
}

resource "aws_route53_record" "tls" {
  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.main.zone_id
}