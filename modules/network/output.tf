############# VPC outputs ###########
output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "web_subnets_ids" {
  value = aws_subnet.web_public_subnets[*].id
}

output "app_subnets_ids" {
  value = aws_subnet.app_private_subnets[*].id
}

output "db_subnets_ids" {
  value = aws_subnet.db_private_subnets[*].id
}


############ Gateway outputs ##############
output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "nat_gw_ids" {
  value = aws_nat_gateway.nat_gw[*].id
}


############# Route table outputs ###########
output "web_rtb_id" {
  value = aws_route_table.web_rtb.id
}

output "app_rtb_ids" {
  value = aws_route_table.app_rtb[*].id
}

output "db_rtb_ids" {
  value = aws_route_table.db_rtb[*].id
}


############# Security groups ouputs ###########
output "web_alb_sg_id" {
  value = aws_security_group.web_alb_sg.id
}

output "web_asg_sg_id" {
  value = aws_security_group.web_asg_sg.id
}

output "app_alb_sg_id" {
  value = aws_security_group.app_alb_sg.id
}

output "app_asg_sg_id" {
  value = aws_security_group.app_asg_sg.id
}

output "db_sg_id" {
  value = aws_security_group.db_sg.id
}