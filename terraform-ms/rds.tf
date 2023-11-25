resource "aws_db_subnet_group" "sub-group" {
  name = "${var.user}-${var.site}-sbgp"
  subnet_ids = [ 
    aws_subnet.priv3.id,
    aws_subnet.priv4.id
   ]
  tags = {
    Name = "${var.user}-${var.site}-sbgp"
  }
}

resource "aws_db_instance" "my-db" {
  allocated_storage    = 10
  db_name              = "drupaldb"
  engine               = "mariadb"
  engine_version       = "10.6.14"
  instance_class       = "db.t2.micro"
  username             = "${var.db_user}"
  password             = "${var.db_pass}"
  backup_retention_period = 7
  multi_az = true
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.sub-group.name
  identifier = "${var.user}-${var.site}-db"
  vpc_security_group_ids = [aws_security_group.db-sg.id]
  
}