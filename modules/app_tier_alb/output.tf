output "app_alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}

output "app_alb_arn" {
  value = aws_lb.app_alb.arn
}

output "app_alb_id" {
  value = aws_lb.app_alb.id
}

output "app_alb_zone_id" {
  value = aws_lb.app_alb.zone_id
}

output "app_alb_tg_arn" {
  value = aws_lb_target_group.app_alb_tg.arn
}

output "app_alb_tg_id" {
  value = aws_lb_target_group.app_alb_tg.id
}