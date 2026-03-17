output "react_asg_name" {
  value = aws_autoscaling_group.react_asg.name
}

output "django_asg_name" {
  value = aws_autoscaling_group.django_asg.name
}