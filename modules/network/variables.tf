# VPC variables
variable "vpc_name" {
  description = "The name of VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
}

variable "availability_zones" {
  description = "availability zones of the VPC"
  type        = list(string)
}

variable "db_subnets" {
  description = "Private subnets for Database"
  type        = list(string)
}

variable "app_subnets" {
  description = "Private subnets for Application"
  type        = list(string)
}

variable "web_subnets" {
  description = "Public subnets for Webserver"
  type        = list(string)
}

# Security Group Variables
variable "web_alb_sg_name" {
  description = "Web ALB SG Name"
  type        = string
  default     = "web-alb-sg"
}

variable "web_sg_name" {
  description = "Web SG Name"
  type        = string
  default     = "web-sg"
}

variable "app_alb_sg_name" {
  description = "App ALB SG Name"
  type        = string
  default     = "app-alb-sg"
}

variable "app_sg_name" {
  description = "App SG Name"
  type        = string
  default     = "app-sg"
}

variable "db_sg_name" {
  description = "DB SG Name"
  type        = string
  default     = "db-sg"
}
