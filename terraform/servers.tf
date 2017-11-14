resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic from my IP"
  vpc_id      = "${aws_vpc.lab_vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "6"
    cidr_blocks = ["95.91.240.3/32"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

variable "app_servers_ssh_key_name" {
  type = "string"
}

variable "app_server_ami_id" {
  type = "string"
}

resource "aws_instance" "app_server" {
  ami = "${var.app_server_ami_id}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.lab_subnet.id}"
  key_name = "${var.app_servers_ssh_key_name}"
  security_groups = ["${aws_security_group.allow_ssh.id}"]

  tags {
    Name = "app-server-001"
  }

  depends_on = ["aws_subnet.lab_subnet"]
}

resource "aws_eip" "app_server_ip" {
  instance = "${aws_instance.app_server.id}"
  vpc = true

  depends_on = ["aws_instance.app_server"]
}