// Subnet privé 1
resource "aws_subnet" "priv1" {
    vpc_id = data.aws_vpc.vpc.id
    cidr_block = "10.0.8.0/24"
    availability_zone = "eu-west-1a"
    tags = {
      Name = "priv1-${var.site}-${var.user}"
      "kubernetes.io/cluster/${var.site}-${var.user}-cls" = "shared"
      "kubernetes.io/role/internal-elb" = "1"
    }
}

resource "aws_route_table" "priv1-rt" {
    vpc_id = data.aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = data.aws_nat_gateway.ngw.id
    }

    tags = {
      Name = "priv1-rt-${var.site}-${var.user}"
    }
}

resource "aws_route_table_association" "priv1-ass" {
    subnet_id = aws_subnet.priv1.id
    route_table_id = aws_route_table.priv1-rt.id
}

// Subnet privé 2
resource "aws_subnet" "priv2" {
    vpc_id = data.aws_vpc.vpc.id
    cidr_block = "10.0.9.0/24"
    availability_zone = "eu-west-1b"
    tags = {
      Name = "priv2-${var.site}-${var.user}"
      "kubernetes.io/cluster/${var.site}-${var.user}-cls" = "shared"
      "kubernetes.io/role/internal-elb" = "1"
    }
}

resource "aws_route_table" "priv2-rt" {
    vpc_id = data.aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = data.aws_nat_gateway.ngw.id
    }

    tags = {
      Name = "priv2-rt-${var.site}-${var.user}"
    }
}

resource "aws_route_table_association" "priv2-ass" {
    subnet_id = aws_subnet.priv2.id
    route_table_id = aws_route_table.priv2-rt.id
}

// Subnet privé 3
resource "aws_subnet" "priv3" {
    vpc_id = data.aws_vpc.vpc.id
    cidr_block = "10.0.18.0/24"
    availability_zone = "eu-west-1a"
    tags = {
      Name = "priv3-${var.site}-${var.user}"
    }
}

resource "aws_route_table" "priv3-rt" {
    vpc_id = data.aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = data.aws_nat_gateway.ngw.id
    }

    tags = {
      Name = "priv3-rt-${var.site}-${var.user}"
    }
}

resource "aws_route_table_association" "priv3-ass" {
    subnet_id = aws_subnet.priv3.id
    route_table_id = aws_route_table.priv3-rt.id
}

// Subnet privé 4
resource "aws_subnet" "priv4" {
    vpc_id = data.aws_vpc.vpc.id
    cidr_block = "10.0.19.0/24"
    availability_zone = "eu-west-1b"
    tags = {
      Name = "priv4-${var.site}-${var.user}"
    }
}

resource "aws_route_table" "priv4-rt" {
    vpc_id = data.aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = data.aws_nat_gateway.ngw.id
    }

    tags = {
      Name = "priv4-rt-${var.site}-${var.user}"
    }
}

resource "aws_route_table_association" "priv4-ass" {
    subnet_id = aws_subnet.priv4.id
    route_table_id = aws_route_table.priv4-rt.id
}


// Subnet public 1
resource "aws_subnet" "pub1" {
    vpc_id = data.aws_vpc.vpc.id
    cidr_block = "10.0.12.0/24"
    availability_zone = "eu-west-1a"
    tags = {
      Name = "pub1-${var.site}-${var.user}"
      "kubernetes.io/cluster/${var.site}-${var.user}-cls" = "shared"
      "kubernetes.io/role/elb" = "1"
    }
}

resource "aws_route_table" "pub1-rt" {
    vpc_id = data.aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = data.aws_internet_gateway.igw.id
    }

    tags = {
      Name = "pub1-rt-${var.site}-${var.user}"
    }
}

resource "aws_route_table_association" "pub1-ass" {
    subnet_id = aws_subnet.pub1.id
    route_table_id = aws_route_table.pub1-rt.id
}

// Subnet public 2
resource "aws_subnet" "pub2" {
    vpc_id = data.aws_vpc.vpc.id
    cidr_block = "10.0.13.0/24"
    availability_zone = "eu-west-1b"
    tags = {
      Name = "pub2-${var.site}-${var.user}"
      "kubernetes.io/cluster/${var.site}-${var.user}-cls" = "shared"
      "kubernetes.io/role/elb" = "1"
    }
}

resource "aws_route_table" "pub2-rt" {
    vpc_id = data.aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = data.aws_internet_gateway.igw.id
    }

    tags = {
      Name = "pub2-rt-${var.site}-${var.user}"
    }
}

resource "aws_route_table_association" "pub2-ass" {
    subnet_id = aws_subnet.pub2.id
    route_table_id = aws_route_table.pub2-rt.id
}