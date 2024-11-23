# APP tier ALB
resource "aws_lb" "app_alb" {
  name               = var.alb_name
  subnets            = var.app_subnet_ids
  load_balancer_type = var.lb_type
  security_groups    = [var.app_alb_sg_id]

  tags = {
    Name = var.alb_name
  }
}

# ALB Target Group for App-Tier Auto Scaling Group
resource "aws_lb_target_group" "app_alb_tg" {
  name     = var.tg_name
  port     = var.tg_port
  protocol = var.tg_protocol
  vpc_id   = var.vpc_id

  # Health check for the web target group
  health_check {
    path                = "/"
    port                = 8081
    protocol            = "HTTP"
    interval            = 60
    timeout             = 30
    healthy_threshold   = 5
    unhealthy_threshold = 3
  }
}

# HTTP Listener
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 8080
  protocol          = "HTTP"

  # Forward to web target group
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_alb_tg.arn
  }
}

