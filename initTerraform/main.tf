###PROVIDER###
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "us-east-1"
  alias      = "us-east-1"
}

###VPC###
resource "aws_vpc" "dep6vpc_US_east" {
  cidr_block       = "10.0.0.0/16"
  
  tags = {
    Name = "Dep6_vpc_East"
  }
}

###SUBNET1###
resource "aws_subnet" "PublicSubnet1" {
  vpc_id     = aws_vpc.dep6vpc_US_east.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a" 
  map_public_ip_on_launch = true

  tags = {
    Name = "D6_Public_Subnet_1"
  }
}

###SUBNET2###
resource "aws_subnet" "PublicSubnet2" {
  vpc_id     = aws_vpc.dep6vpc_US_east.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b" 
  map_public_ip_on_launch = true

  tags = {
    Name = "D6_Public_Subnet_2"
  }
}

###INSTANCE1###
resource "aws_instance" "BankApp01" {
  ami                    = "ami-08c40ec9ead489470"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.Dep6_SG_East.id]
  availability_zone = "us-east-1b"
  associate_public_ip_address = true
  key_name = "Dep6KeyPair"
  user_data = file("BankAppDeploy.sh")
  subnet_id     = aws_subnet.PublicSubnet1.id
  tags = {
    "Name" : "Dep6_BankApp_Server"
  }
}

###INSTANCE2###
resource "aws_instance" "BankApp02" {
  ami           = "ami-08c40ec9ead489470" 
  instance_type = "t2.micro"    
  subnet_id     = aws_subnet.PublicSubnet1.id
  vpc_security_group_ids = [aws_security_group.Dep6_SG_East.id]
  availability_zone = "us-east-1b"
  associate_public_ip_address = true
  key_name = "Dep6KeyPair"
  user_data = file("BankAppDeploy.sh")
  tags = {
    "Name" : "Dep6_BankApp2nd_Server"
  }
}


###INTERNETGATEWAY###
resource "aws_internet_gateway" "D6GatewayEast" {
  vpc_id = aws_vpc.dep6vpc_US_east.id

  tags = {
    Name = "GW_d6_East"
  }
}

###ELB###
resource "aws_elb" "D6_elb" {
  name               = "D6-load-balancer"
  subnets            = [aws_subnet.PublicSubnet1.id, aws_subnet.PublicSubnet2.id, aws_subnet.PublicSubnet3.id, aws_subnet.PublicSubnet4.id]
  security_groups    = [aws_security_group.Dep6_SG_East.id, aws_security_group.Dep6_SG_West.id]
  
  listener {
    instance_port     = 8000
    instance_protocol = "tcp"
    lb_port           = 80
    lb_protocol       = "tcp"
  }
  
  health_check {
    target             = "HTTP:8080/"
    interval           = 30
    healthy_threshold  = 2
    unhealthy_threshold = 2
    timeout            = 5
  }

  tags = {
    Name = "D6ELB"
  }
}


###ROUTETABLE###

resource "aws_route_table" "D6RouteEast" {
  vpc_id = aws_vpc.dep6vpc_US_east.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.D6GatewayEast.id
  }
}

###SECURITYGROUP###
resource "aws_security_group" "Dep6_SG_East" {
  name        = "Dep6_SG_East"
  description = "open ssh traffic"
  vpc_id      = aws_vpc.dep6vpc_US_east.id

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

tags = {
    "Name" : "Deployment_6_Security_Group"
    "Terraform" : "true"
  }

}

###PROVIDER2###
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "us-west-2"
  alias      = "us-west-2"
}

###VPC2###
resource "aws_vpc" "dep6vpc_US_west" {
  cidr_block       = "10.0.0.0/16"
  
  tags = {
    Name = "Dep6_vpc_West"
  }
}

###SUBNET1###
resource "aws_subnet" "PublicSubnet3" {
  vpc_id     = aws_vpc.dep6vpc_US_west.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-1a" 
  map_public_ip_on_launch = true

  tags = {
    Name = "D6_Public_Subnet_3"
  }
}

###SUBNET2###
resource "aws_subnet" "PublicSubnet4" {
  vpc_id     = aws_vpc.dep6vpc_US_west.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-1b" 
  map_public_ip_on_launch = true

  tags = {
    Name = "D6_Public_Subnet_4"
  }
}


###INSTANCE3###
resource "aws_instance" "BankApp03" {
  ami                         = "ami-08c40ec9ead489470"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.Dep6_SG_West.id]
  availability_zone           = "us-west-1a"
  associate_public_ip_address = true
  key_name                    = "Dep6KeyPair"
  user_data                   = file("BankAppDeploy.sh")
  subnet_id                   = aws_subnet.PublicSubnet3.id

  tags = {
    "Name" : "Dep6_BankApp_Server"
  }
}

###INSTANCE4###
resource "aws_instance" "BankApp04" {
  ami                         = "ami-08c40ec9ead489470" 
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.Dep6_SG_West.id]
  availability_zone           = "us-west-2b"
  associate_public_ip_address = true
  key_name                    = "Dep6KeyPair"
  subnet_id                   = aws_subnet.PublicSubnet4.id
  user_data                   = file("BankAppDeploy.sh")

  tags = {
    "Name" : "Dep6_BankApp2nd_Server"
  }
}


###SECURITYGROUP2###
resource "aws_security_group" "Dep6_SG_West" {
  name          = "Dep6_SG_West"
  description   = "open ssh traffic"
  vpc_id        = aws_vpc.dep6vpc_US_west.id

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

tags = {
    "Name" : "Deployment_6_Security_Group"
    "Terraform" : "true"
  }

}

###INTERNETGATEWAY2###
resource "aws_internet_gateway" "D6GatewayWest" {
  vpc_id = aws_vpc.dep6vpc_US_west.id

  tags = {
    Name = "GW_d6_West"
  }
}

###ROUTETABLE2###
resource "aws_route_table" "D6RouteWest" {
  vpc_id = aws_vpc.dep6vpc_US_west.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.D6GatewayWest.id
  }
}

###TableAssociation###
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.PublicSubnet1.id
  route_table_id = aws_route_table.D6RouteEast.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.PublicSubnet2.id
  route_table_id = aws_route_table.D6RouteEast.id
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.PublicSubnet3.id
  route_table_id = aws_route_table.D6RouteWest.id
}

resource "aws_route_table_association" "d" {
  subnet_id      = aws_subnet.PublicSubnet1.id
  route_table_id = aws_route_table.D6RouteWest.id
}