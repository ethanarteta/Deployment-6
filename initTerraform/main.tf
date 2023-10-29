###PROVIDER2###
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "us-west-2"
}

###VPC2###
resource "aws_vpc" "dep6vpc_US_west" {
  cidr_block       = "10.1.0.0/16"
  
  tags = {
    Name = "Dep6_vpc_West"
  }
}

###SUBNET1###
resource "aws_subnet" "PublicSubnet3" {
  vpc_id     = aws_vpc.dep6vpc_US_west.id
  cidr_block = "10.1.1.0/24"
  availability_zone = "us-west-2a" 
  map_public_ip_on_launch = true

  tags = {
    Name = "D6_Public_Subnet_3"
  }
}

###SUBNET2###
resource "aws_subnet" "PublicSubnet4" {
  vpc_id     = aws_vpc.dep6vpc_US_west.id
  cidr_block = "10.1.2.0/24"
  availability_zone = "us-west-2b" 
  map_public_ip_on_launch = true

  tags = {
    Name = "D6_Public_Subnet_4"
  }
}


###INSTANCE3###
resource "aws_instance" "BankApp03" {
  ami                         = "ami-0efcece6bed30fd98"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.Dep6_SG_West.id]
  availability_zone           = "us-west-2a"
  associate_public_ip_address = true
  key_name                    = "dep6west"
  user_data                   = file("BankAppDeploy.sh")
  subnet_id                   = aws_subnet.PublicSubnet3.id

  tags = {
    "Name" : "Dep6_BankApp_Server"
  }
}

###INSTANCE4###
resource "aws_instance" "BankApp04" {
  ami                         = "ami-0efcece6bed30fd98" 
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.Dep6_SG_West.id]
  availability_zone           = "us-west-2b"
  associate_public_ip_address = true
  key_name                    = "dep6west"
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
resource "aws_internet_gateway" "gw_west" {
  vpc_id = aws_vpc.dep6vpc_US_west.id

  tags = {
    Name = "gw_d6_west"
  }
}

###ROUTETABLE2###
resource "aws_route_table" "D6RouteWest" {
  vpc_id = aws_vpc.dep6vpc_US_west.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_west.id
  }
}

###TableAssociation###
resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.PublicSubnet3.id
  route_table_id = aws_route_table.D6RouteWest.id
}

resource "aws_route_table_association" "d" {
  subnet_id      = aws_subnet.PublicSubnet4.id
  route_table_id = aws_route_table.D6RouteWest.id
}
