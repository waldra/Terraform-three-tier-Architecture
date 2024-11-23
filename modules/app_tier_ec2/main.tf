####################### App-Tier #########################
# launch template configuration for app-tier autoscaling group
resource "aws_launch_template" "app_lt_asg" {
  name                   = var.lt_name
  image_id               = var.lt_ami_id
  instance_type          = var.lt_instance_type
  vpc_security_group_ids = [var.app_sg_id]
}

# autoscaling group for the app servers
resource "aws_autoscaling_group" "app_asg" {
  name                = var.asg_name
  min_size            = var.asg_min
  max_size            = var.asg_max
  desired_capacity    = var.asg_des_cap
  vpc_zone_identifier = var.app_subnets_ids

  launch_template {
    id = aws_launch_template.app_lt_asg.id
  }

  tag {
    key                 = "Name"
    value               = var.asg_name
    propagate_at_launch = true
  }
}

# Attach the autoscaling group to the target group of the app ALB
resource "aws_autoscaling_attachment" "app_asg_tg_attach" {
  autoscaling_group_name = aws_autoscaling_group.app_asg.id
  lb_target_group_arn    = var.app_alb_tg_arn
}
