data "aws_vpc" "vpc" {
  tags = {
    Name = "VPC-A"
  }
}

data "aws_internet_gateway" "igw" {
  tags = {
    Name = "IGW-A"
  }
}

data "aws_nat_gateway" "ngw" {
  tags = {
    Name = "NGW-A"
  }
}

data "aws_security_group" "jenkins-sg" {
  name = "kebi-jenkins-sg"
}

data "aws_route53_zone" "zone" {
  name = "kevin-billerach.me"
}

data "aws_acm_certificate" "certificate" {
  domain = "kevin-billerach.me"
}