###Provider###
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = "us-east-1"
}

###VPC###
resource "aws_default_vpc" "default" {}

###SecurityGroup###
data "aws_security_group" "ExistingSG" {
  id = var.SecurityGroup
}

###INSTANCE1###
resource "aws_instance" "JenkinsManager" {
  ami                         = "ami-08c40ec9ead489470"
  instance_type               = "t2.micro"
  availability_zone           = "us-east-1a"
  associate_public_ip_address = true
  vpc_security_group_ids      = [data.aws_security_group.ExistingSG.id] 
  key_name                    = "Dep6KeyPair"
  user_data                   = file("JenkinsManagerInstall.sh")
    tags = {
    "Name" : "Dep6_JenkinsManager"
  }
}

###INSTANCE2###
resource "aws_instance" "JenkinsAgent" {
  ami                         = "ami-08c40ec9ead489470"
  instance_type               = "t2.micro"
  availability_zone           = "us-east-1a"
  associate_public_ip_address = true
  vpc_security_group_ids      = [data.aws_security_group.ExistingSG.id]
  key_name                    = "Dep6KeyPair"
  user_data                   = file("TerraformInstall.sh")
    tags = {
    "Name" : "Dep6_Terraform"
  }
}
