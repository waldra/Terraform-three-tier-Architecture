variable "hosted_zone_name" {
  description = "Name of public hosted zone"
  type        = string
  default     = "waldra.net"
}

variable "cloudfront_domain_name" {
  description = "Domain name of cloudfront"
  type        = string
}

variable "cloudfront_hosted_zone_id" {
  description = "Hosted zone ID of the cloudfront"
  type        = string
}