output "certificate_arn" {
  description = "The ARN of the VALIDATED certificate. LB depends on this."
  value       = aws_acm_certificate_validation.cert.certificate_arn
}

output "hosted_zone_id" {
  description = "The ID of the newly created Route53 zone"
  value       = aws_route53_zone.main.zone_id
}

output "name_servers" {
  description = "The 4 Nameservers you MUST provide to your registrar (GoDaddy/etc)"
  value       = aws_route53_zone.main.name_servers
}

output "mongo_param_name" {
  description = "The name of the SSM parameter for the compute module"
  value       = aws_ssm_parameter.mongodb_url.name
}