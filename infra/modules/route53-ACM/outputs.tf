output "route53_domain_name" {
  value = data.aws_route53_zone.main.name
}
output "route53_zone_arns" {
  value = data.aws_route53_zone.main.arn
}
output "certificate_arn" {
  value = aws_acm_certificate.cert.arn
}