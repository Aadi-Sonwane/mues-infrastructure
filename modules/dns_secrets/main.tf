# 1. Store MongoDB URL in SSM Parameter Store
resource "aws_ssm_parameter" "mongodb_url" {
  name        = "/${var.env}/backend/mongodb_url"
  description = "Connection string for external MongoDB"
  type        = "SecureString"
  value       = var.mongodb_url

  tags = { Env = var.env }
}

# 2. CREATE the Route53 Hosted Zone (Replaces the data block)
resource "aws_route53_zone" "main" {
  name = var.domain_name

  tags = {
    Name = "${var.env}-hosted-zone"
  }
}

# 3. ACM Certificate for SSL
resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  # Recommended: Add a wildcard to cover subdomains if needed later
  subject_alternative_names = ["*.${var.domain_name}"]

  lifecycle {
    create_before_destroy = true
  }
}

# 4. DNS Validation Record
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
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
  zone_id         = aws_route53_zone.main.zone_id # Updated to reference resource
}

# 5. Wait for Certificate Validation (CRITICAL for automation)
# This resource tells Terraform to "pause" until AWS confirms the SSL is valid.
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

# 6. Route53 Alias Record for ALB
resource "aws_route53_record" "app" {
  zone_id = aws_route53_zone.main.zone_id # Updated to reference resource
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}