resource "aws_instance" "webserver-1" {
  ami = "ami-0eb11ab33f229b26c"
  instance_type = "t2.small"
  key_name = "kev-key-its"
  subnet_id = aws_subnet.priv1.id
  vpc_security_group_ids = [aws_security_group.drupal-sg.id]
  tags = {
    Name = "${var.site}-1-${var.user}"
  }
  volume_tags = {
    owner = "kbillerach@thenuumfactory.fr"
    ephemere = "non"
    entity = "numfactory"
  }
}

resource "aws_instance" "webserver-2" {
  ami = "ami-0eb11ab33f229b26c"
  instance_type = "t2.small"
  key_name = "kev-key-its"
  subnet_id = aws_subnet.priv2.id
  vpc_security_group_ids = [aws_security_group.drupal-sg.id]
  tags = {
    Name = "${var.site}-2-${var.user}"
  }
  volume_tags = {
    owner = "kbillerach@thenuumfactory.fr"
    ephemere = "non"
    entity = "numfactory"
  }
}

resource "aws_instance" "db" {
  ami = "ami-0eb11ab33f229b26c"
  instance_type = "t2.micro"
  key_name = "kev-key-its"
  subnet_id = aws_subnet.priv3.id
  vpc_security_group_ids = [aws_security_group.db-sg.id]
  tags = {
    Name = "${var.site}-db-${var.user}"
  }

  volume_tags = {
    owner = "kbillerach@thenuumfactory.fr"
    ephemere = "non"
    entity = "numfactory"
  }
}

resource "local_file" "inventory" {
  filename = "../ansible-drupal/hosts"
  content = <<EOF
[web_server]
web-server1 ansible_ssh_host=${aws_instance.webserver-1.private_ip} ansible_ssh_user=admin
web-server2 ansible_ssh_host=${aws_instance.webserver-2.private_ip} ansible_ssh_user=admin
[database]
db-server ansible_ssh_host=${aws_instance.db.private_ip} ansible_ssh_user=admin

[all:vars]
ansible_python_interpreter=/usr/bin/python3
EOF
}