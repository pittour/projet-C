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

data "aws_security_group" "agent-sg" {
  name = "kebi-agent-sg"
}

data "aws_route53_zone" "zone" {
  name = "kevin-billerach.me"
}

data "aws_acm_certificate" "certificate" {
  domain = "kevin-billerach.me"
}

data "aws_iam_role" "eks-role" {
  name = "eks-iam-role"
}

data "aws_iam_role" "node-role" {
  name = "eksworkernodes-iam-role"
}