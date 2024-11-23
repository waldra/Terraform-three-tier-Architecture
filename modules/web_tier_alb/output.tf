output "web_alb_dns_name" {
  value = aws_lb.web_alb.dns_name
}

output "web_alb_arn" {
  value = aws_lb.web_alb.arn
}

output "web_alb_id" {
  value = aws_lb.web_alb.id
}

output "web_alb_zone_id" {
  value = aws_lb.web_alb.zone_id
}

output "web_alb_tg_arn" {
  value = aws_lb_target_group.web_alb_tg.arn
}

output "web_alb_tg_id" {
  value = aws_lb_target_group.web_alb_tg.id
}