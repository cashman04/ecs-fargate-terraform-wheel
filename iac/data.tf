data "aws_route53_zone" "main" {
  name         = "${var.hosted_zone}."
  private_zone = false
}