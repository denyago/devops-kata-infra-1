resource "aws_vpc" "lab_vpc" {
  cidr_block = "10.10.0.0/16"
  enable_dns_hostnames = true

  tags {
    Name = "Lab-2 VPC"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.lab_vpc.id}"

  tags {
    Name = "Lab-2 Inet GW"
  }
}

resource "aws_subnet" "lab_subnet" {
  vpc_id     = "${aws_vpc.lab_vpc.id}"
  cidr_block = "10.10.1.0/24"

  tags {
    Name = "Lab-2 Subnet"
  }

  depends_on = ["aws_vpc.lab_vpc"]
}

resource "aws_route_table" "lab_routing_table" {
  vpc_id = "${aws_vpc.lab_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "Lab-2 VPC Routing Table"
  }
}

resource "aws_route_table_association" "lab_subnet_and_routing" {
  subnet_id      = "${aws_subnet.lab_subnet.id}"
  route_table_id = "${aws_route_table.lab_routing_table.id}"
}