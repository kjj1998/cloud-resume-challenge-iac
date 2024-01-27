output "route53_record_name" {
  description = "Name of the route53 record."
  value = aws_route53_record.route53_record.name
}