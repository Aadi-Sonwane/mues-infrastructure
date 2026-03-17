output "website_url" {
  value = "https://${var.domain_name}"
}

output "alb_dns_name" {
  value = module.lb.alb_dns_name
}

output "nameservers_to_verify" {
  value = module.dns_secrets.name_servers
}
output "certificate_status" {
  value = "Check ACM Console: https://console.aws.amazon.com/acm/home"
}