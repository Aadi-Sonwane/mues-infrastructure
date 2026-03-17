# --- PUBLIC ALB (Frontend) ---

resource "aws_lb" "public_alb" {
  name               = "${var.env}-public-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnets

  tags = { Name = "${var.env}-public-alb" }
}

resource "aws_lb_target_group" "react_tg" {
  name     = "${var.env}-react-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.public_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.react_tg.arn
  }
}

# --- INTERNAL NLB (Backend API) ---

resource "aws_lb" "internal_nlb" {
  name               = "${var.env}-internal-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.private_subnets

  tags = { Name = "${var.env}-internal-nlb" }
}

resource "aws_lb_target_group" "django_tg" {
  name     = "${var.env}-django-tg"
  port     = 8000
  protocol = "TCP"
  vpc_id   = var.vpc_id

  health_check {
    port     = "8000"
    protocol = "TCP"
  }
}

resource "aws_lb_listener" "django_listener" {
  load_balancer_arn = aws_lb.internal_nlb.arn
  port              = "8000"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.django_tg.arn
  }
}