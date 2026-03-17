output "alb_dns_name" {
  value = aws_lb.public_alb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.public_alb.zone_id
}

output "react_tg_arn" {
  value = aws_lb_target_group.react_tg.arn
}

output "nlb_dns_name" {
  value = aws_lb.internal_nlb.dns_name
}

output "django_tg_arn" {
  value = aws_lb_target_group.django_tg.arn
}