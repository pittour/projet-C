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