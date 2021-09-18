data "aws_route53_zone" "dancash" {
  name         = "dan.cash."
  private_zone = false
}