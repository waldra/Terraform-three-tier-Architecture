###################### Network ######################
#####################################################

# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }

}

# Subnets

# [1] web-tier public subnets 
resource "aws_subnet" "web_public_subnets" {
  count                   = length(var.web_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.web_subnets[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "web_subnet-${count.index + 1}"
  }

}
# [2] app-tier private subnets 
resource "aws_subnet" "app_private_subnets" {
  count             = length(var.app_subnets)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.app_subnets[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "app_subnet-${count.index + 1}"
  }

}
# [3] db-tier private subnets 
resource "aws_subnet" "db_private_subnets" {
  count                   = length(var.db_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.db_subnets[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "db_subnet-${count.index + 1}"
  }

}



#################### Route Tables #######################
#########################################################

# [1] Route table for web subnets
resource "aws_route_table" "web_rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "web-rtb"
  }
}
# Associate web subnets with the route table
resource "aws_route_table_association" "web_rtb_association" {
  count          = length(var.web_subnets)
  subnet_id      = aws_subnet.web_public_subnets[count.index].id
  route_table_id = aws_route_table.web_rtb.id
}

# [2] Route tables for app subnets, one route table for each subnet
resource "aws_route_table" "app_rtb" {
  count  = length(var.app_subnets)
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[count.index].id
  }

  tags = {
    Name = "app-rtb-${count.index + 1}"
  }

}
# Associate each app subnet with route table
resource "aws_route_table_association" "app_rtb_association" {
  count          = length(var.app_subnets)
  subnet_id      = aws_subnet.app_private_subnets[count.index].id
  route_table_id = aws_route_table.app_rtb[count.index].id
}

# [3] Route tables for DB subnets, one route table for each subnet
resource "aws_route_table" "db_rtb" {
  count  = length(var.db_subnets)
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[count.index].id
  }

  tags = {
    Name = "db-rtb-${count.index + 1}"
  }

}
# Associate each DB subnet with route table
resource "aws_route_table_association" "db_rtb_association" {
  count          = length(var.db_subnets)
  subnet_id      = aws_subnet.db_private_subnets[count.index].id
  route_table_id = aws_route_table.db_rtb[count.index].id
}


###################### Security Groups ##########################
#################################################################

# [1] Web ALB security group
resource "aws_security_group" "web_alb_sg" {
  name        = var.web_alb_sg_name
  description = "Allow inbound HTTP/HTTPS traffic from the inetnet"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound to web instances"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [aws_vpc.vpc]

  tags = {
    Name = var.web_alb_sg_name
  }
}

# [2] security group for web-tier autoscaling group
resource "aws_security_group" "web_asg_sg" {
  name        = var.web_sg_name
  description = "Allow traffic from Web ALB to web instances"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "Allow traffic from Web ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web_alb_sg.id]
  }

  ingress {
    description = "Allow traffic from Web ALB"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all egress traffic"
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.web_sg_name
  }

}

# [3] App ALB security group
resource "aws_security_group" "app_alb_sg" {
  name        = var.app_alb_sg_name
  description = "Allow traffic from web-tier to App ALB"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "Allow traffic from Web Instances"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.web_asg_sg.id]
  }

  egress {
    description = "Allow outbound to App Instances"
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# [4] security group for app-tier autoscaling group
resource "aws_security_group" "app_asg_sg" {
  name        = var.app_sg_name
  description = "Allow traffic from App ALB to app instances"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "Allow traffic from App ALB"
    from_port       = 8081
    to_port         = 8081
    protocol        = "tcp"
    security_groups = [aws_security_group.app_alb_sg.id]
  }

  egress {
    description = "Allow outbound to Database"
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.app_sg_name
  }

}

# [5] db-tier security group
resource "aws_security_group" "db_sg" {
  name        = var.db_sg_name
  description = "Allow traffic from App Instances to the database"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "Allow traffic from App Instances"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_asg_sg.id]
  }

  egress {
    description = "Restrict outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = []
  }

  tags = {
    Name = var.db_sg_name
  }

}


########################## Gateway ###########################
##############################################################

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw"
  }
}

# Elastic IPs for the NAT gatewaies, one eip per NAT gateway
resource "aws_eip" "nat_gw_eip" {
  count  = length(var.web_subnets)
  domain = "vpc"

  tags = {
    Name = "eip-${count.index + 1}"
  }
}

# NAT gatewaies, each in a different public subnet
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_gw_eip[count.index].id
  subnet_id     = aws_subnet.web_public_subnets[count.index].id
  count         = length(var.web_subnets)

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "ngw-${count.index + 1}"
  }
}
