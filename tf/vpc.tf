provider "aws" {
  region = "${var.region}"
}

resource "aws_vpc" "main" {
  cidr_block           = "10.12.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.main.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main.id}"
}

resource "aws_subnet" "subnet-a" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.12.16.0/20"
  availability_zone = "${var.region}a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet-b" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.12.32.0/20"
  availability_zone = "${var.region}b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet-c" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.12.48.0/20"
  availability_zone = "${var.region}c"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "exposed" {
  name   = "exposed"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.12.0.0/16"]
  }

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
