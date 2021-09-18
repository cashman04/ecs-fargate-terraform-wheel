resource "aws_acm_certificate" "main" {
  domain_name       = "${var.name}.${var.hosted_zone}"
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for record in aws_route53_record.tls : record.fqdn]
}