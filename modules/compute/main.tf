# --- Launch Template for React ---
resource "aws_launch_template" "react" {
  name_prefix   = "${var.env}-react-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.react_sg_id]
  }

  iam_instance_profile {
    name = var.instance_profile_name
  }

  # Enforce IMDSv2
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  user_data = base64encode(templatefile("${path.module}/scripts/init_frontend.sh", {}))

  tag_specifications {
    resource_type = "instance"
    tags          = { Name = "${var.env}-react-app" }
  }
}

# --- ASG for React with Mixed Instances ---
resource "aws_autoscaling_group" "react_asg" {
  vpc_zone_identifier = var.private_subnets
  target_group_arns   = [var.react_tg_arn]
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 30 # 70% Spot
      spot_allocation_strategy                 = "capacity-optimized"
    }
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.react.id
        version            = "$Latest"
      }
    }
  }
}

# --- Launch Template for Django ---
resource "aws_launch_template" "django" {
  name_prefix   = "${var.env}-django-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.django_sg_id]
  }

  iam_instance_profile {
    name = var.instance_profile_name
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
  }

  user_data = base64encode(templatefile("${path.module}/scripts/init_backend.sh", {
    mongo_url_param = var.mongo_url_param_name
    region          = var.region
  }))

  tag_specifications {
    resource_type = "instance"
    tags          = { Name = "${var.env}-django-api" }
  }
}

# --- ASG for Django ---
resource "aws_autoscaling_group" "django_asg" {
  vpc_zone_identifier = var.private_subnets
  target_group_arns   = [var.django_tg_arn]
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 30
      spot_allocation_strategy                 = "capacity-optimized"
    }
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.django.id
        version            = "$Latest"
      }
    }
  }
}