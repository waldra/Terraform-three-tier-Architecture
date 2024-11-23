# Web-Tier variables
variable "lt_name" {
  description = "The name of Launch Template"
  type        = string
  default     = "webserver-lt"
}

variable "lt_ami_id" {
  description = "AMI ID for instances"
  type        = string
}

variable "lt_instance_type" {
  description = "Instance type for the EC2"
  type        = string
}

variable "lt_key_name" {
  description = "SSH key name to use for EC2"
  type        = string
}

variable "asg_name" {
  description = "Autoscaling group name"
  type        = string
  default     = "web-tier-asg"
}

variable "web_sg_id" {
  description = "Security group ID for EC2 (web) instances"
  type        = string
}

variable "web_subnets_ids" {
  description = "Autoscaling group for web subnet IDs"
  type        = list(string)
}

variable "web_alb_tg_arn" {
  description = "The ARN of the web ALB target group to attach"
  type        = string
}

variable "asg_des_cap" {
  description = "Desired number of instances in the ASG"
  type        = number
  default     = 2
}

variable "asg_max" {
  description = "Maximum number of instances in the ASG"
  type        = number
  default     = 3
}

variable "asg_min" {
  description = "Minimum number of instances in the ASG"
  type        = number
  default     = 1
}