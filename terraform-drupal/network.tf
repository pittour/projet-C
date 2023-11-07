// Subnet privé 1
resource "aws_subnet" "priv1" {
    vpc_id = data.aws_vpc.vpc.id
    cidr_block = "10.0.5.0/24"
    availability_zone = "eu-west-1a"
    tags = {
      Name = "priv1-${var.user}"
    }
}

resource "aws_route_table" "priv1-rt" {
    vpc_id = data.aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = data.aws_nat_gateway.ngw.id
    }

    tags = {
      Name = "priv1-rt-${var.user}"
    }
}

resource "aws_route_table_association" "priv1-ass" {
    subnet_id = aws_subnet.priv1.id
    route_table_id = aws_route_table.priv1-rt.id
}

// Subnet privé 2
resource "aws_subnet" "priv2" {
    vpc_id = data.aws_vpc.vpc.id
    cidr_block = "10.0.6.0/24"
    availability_zone = "eu-west-1b"
    tags = {
      Name = "priv2-${var.user}"
    }
}

resource "aws_route_table" "priv2-rt" {
    vpc_id = data.aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = data.aws_nat_gateway.ngw.id
    }

    tags = {
      Name = "priv2-rt-${var.user}"
    }
}

resource "aws_route_table_association" "priv2-ass" {
    subnet_id = aws_subnet.priv2.id
    route_table_id = aws_route_table.priv2-rt.id
}


// Subnet privé 3
resource "aws_subnet" "priv3" {
    vpc_id = data.aws_vpc.vpc.id
    cidr_block = "10.0.7.0/24"
    availability_zone = "eu-west-1a"
    tags = {
      Name = "priv3-${var.user}"
    }
}

resource "aws_route_table" "priv3-rt" {
    vpc_id = data.aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = data.aws_nat_gateway.ngw.id
    }

    tags = {
      Name = "priv3-rt-${var.user}"
    }
}

resource "aws_route_table_association" "priv3-ass" {
    subnet_id = aws_subnet.priv3.id
    route_table_id = aws_route_table.priv3-rt.id
}

// Subnet public 1
resource "aws_subnet" "pub1" {
    vpc_id = data.aws_vpc.vpc.id
    cidr_block = "10.0.10.0/24"
    availability_zone = "eu-west-1a"
    tags = {
      Name = "pub1-${var.user}"
    }
}

resource "aws_route_table" "pub1-rt" {
    vpc_id = data.aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = data.aws_internet_gateway.igw.id
    }

    tags = {
      Name = "pub1-rt-${var.user}"
    }
}

resource "aws_route_table_association" "pub1-ass" {
    subnet_id = aws_subnet.pub1.id
    route_table_id = aws_route_table.pub1-rt.id
}

// Subnet public 2
resource "aws_subnet" "pub2" {
    vpc_id = data.aws_vpc.vpc.id
    cidr_block = "10.0.11.0/24"
    availability_zone = "eu-west-1b"
    tags = {
      Name = "pub2-${var.user}"
    }
}

resource "aws_route_table" "pub2-rt" {
    vpc_id = data.aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = data.aws_internet_gateway.igw.id
    }

    tags = {
      Name = "pub2-rt-${var.user}"
    }
}

resource "aws_route_table_association" "pub2-ass" {
    subnet_id = aws_subnet.pub2.id
    route_table_id = aws_route_table.pub2-rt.id
}