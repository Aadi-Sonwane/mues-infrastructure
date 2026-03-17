output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "react_sg_id" {
  value = aws_security_group.react_sg.id
}

output "django_sg_id" {
  value = aws_security_group.django_sg.id
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.ec2_profile.name
}

output "iam_role_name" {
  value = aws_iam_role.ec2_role.name
}