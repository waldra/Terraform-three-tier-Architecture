variable "alb_name" {
  description = "Name of application load balancer"
  type        = string
  default     = "app-tier-alb"
}

variable "app_subnet_ids" {
  description = "IDs of public subnets for ALB"
  type        = list(string)
}

variable "lb_type" {
  description = "Load balancer type"
  type        = string
  default     = "application"
}

variable "app_alb_sg_id" {
  description = "Loab balancer security group"
  type        = string
}

variable "tg_name" {
  description = "Name of autoscaling target group"
  type        = string
  default     = "app-tier-tg"
}

variable "tg_port" {
  description = "Target group port where traffic is forwarded to"
  type        = number
  default     = 8081
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
