variable "alb_name" {
  description = "The name of application load balancer to create"
  type        = string
  default     = "web-tier-alb"
}

variable "web_subnet_ids" {
  description = "IDs of public subnets for ALB"
  type        = list(string)
}

variable "lb_type" {
  description = "Type of load balancer to create"
  type        = string
  default     = "application"
}

variable "web_alb_sg_id" {
  description = "Security group of the load balacner"
  type        = string
}

variable "tg_name" {
  description = "Name of autoscaling target group"
  type        = string
  default     = "webserver-tg"
}

variable "tg_port" {
  description = "Target group port where traffic is forwarded to"
  type        = number
  default     = 80
}

variable "tg_protocol" {
  description = "Target group protocol"
  type        = string
  default     = "HTTP"
}

variable "vpc_id" {
  description = "ID of VPC"
  type        = string
}
