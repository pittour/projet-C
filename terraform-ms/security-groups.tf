# Pour source SG des pods https://www.eksworkshop.com/docs/networking/security-groups-for-pods/add-sg
resource "aws_security_group" "db-sg" {
  name   = "${var.user}-${var.site}-dbsg"
  vpc_id = data.aws_vpc.vpc.id
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    # security_groups = [id]
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.user}-${var.site}-dbsg"
  }
}

# SG du load balancer ms
resource "aws_security_group" "lb-sg" {
  name   = "${var.site}-lb-sg-${var.user}"
  vpc_id = data.aws_vpc.vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [data.aws_security_group.jenkins-sg.id, data.aws_security_group.agent-sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.site}-lb-sg-${var.user}"
  }
}

# Security rules de l'EKS
resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
  from_port = 31000
  to_port = 31000
  ip_protocol = "tcp"
  referenced_security_group_id = aws_security_group.lb-sg.id
}

resource "aws_vpc_security_group_ingress_rule" "redis" {
  security_group_id = aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
  from_port = 32000
  to_port = 32000
  ip_protocol = "tcp"
  referenced_security_group_id = aws_security_group.lb-sg.id
}