# Network
module "vpc" {
  source             = "./modules/network"
  vpc_name           = "three-tier"
  vpc_cidr           = "10.0.0.0/16"
  web_subnets        = ["10.0.1.0/24", "10.0.2.0/24"]
  app_subnets        = ["10.0.3.0/24", "10.0.4.0/24"]
  db_subnets         = ["10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["eu-west-1a", "eu-west-1b"]
}

# Web-tier (EC2)
module "web_ec2" {
  source           = "./modules/web_tier_ec2"
  lt_ami_id        = "ami-0d64bb532e0502c46"
  lt_instance_type = "t2.micro"
  lt_key_name      = "DevOps"
  web_sg_id        = module.vpc.web_asg_sg_id
  web_subnets_ids  = module.vpc.web_subnets_ids
  web_alb_tg_arn   = module.web_alb.web_alb_tg_arn
}

# Web-tier (ALB)
module "web_alb" {
  source         = "./modules/web_tier_alb"
  vpc_id         = module.vpc.vpc_id
  web_alb_sg_id  = module.vpc.web_alb_sg_id
  web_subnet_ids = module.vpc.web_subnets_ids
}

# App-tier (EC2)
module "app_ec2" {
  source           = "./modules/app_tier_ec2"
  lt_ami_id        = "ami-0d64bb532e0502c46"
  lt_instance_type = "t2.micro"
  app_sg_id        = module.vpc.app_asg_sg_id
  app_subnets_ids  = module.vpc.app_subnets_ids
  app_alb_tg_arn   = module.app_alb.app_alb_tg_arn
}

# App-tier (ALB)
module "app_alb" {
  source         = "./modules/app_tier_alb"
  vpc_id         = module.vpc.vpc_id
  app_alb_sg_id  = module.vpc.app_alb_sg_id
  app_subnet_ids = module.vpc.app_subnets_ids
}
/*
# Database
module "db" {
  source     = "./modules/db_tier"
  username   = var.db_username
  password   = var.db_password
  subnet_ids = module.vpc.db_subnets_ids
  db_sg_id   = module.vpc.db_sg_id
}
*/
# CloudFront
module "cloudfront" {
  source           = "./modules/cloudfront"
  certificate_arn  = var.cert_arn
  web_alb_dns_name = module.web_alb.web_alb_dns_name
  waf_acl_arn      = module.waf.waf_acl_arn
}

# WAF ACL
module "waf" {

  providers = {
    aws = aws.global
  }

  source   = "./modules/waf"
  waf_name = "Web-WAF"
}

# Route53
module "dns" {
  source                    = "./modules/route53"
  cloudfront_domain_name    = module.cloudfront.cloudfront_domain_name
  cloudfront_hosted_zone_id = module.cloudfront.cloudfront_hosted_zone_id
}

