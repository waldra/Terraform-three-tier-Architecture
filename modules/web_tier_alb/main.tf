# Web tier ALB
resource "aws_lb" "web_alb" {
  name               = var.alb_name
  subnets            = var.web_subnet_ids
  load_balancer_type = var.lb_type
  security_groups    = [var.web_alb_sg_id]

  tags = {
    Name = var.alb_name
  }
}

# ALB Target Group for Web Auto Scaling Group
resource "aws_lb_target_group" "web_alb_tg" {
  name     = var.tg_name
  port     = var.tg_port
  protocol = var.tg_protocol
  vpc_id   = var.vpc_id

  # Health check for the web target group
  health_check {
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    interval            = 60
    timeout             = 30
    healthy_threshold   = 5
    unhealthy_threshold = 3
  }
}

# HTTP Listener
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  # Forward to web target group
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_alb_tg.arn
  }
}

