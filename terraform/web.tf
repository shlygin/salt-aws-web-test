provider "aws" {
    access_key = "${var.access}"
    secret_key = "${var.secret}"
    profile = "${var.profile}"
    region = "${var.region}"
}

variable "profile" {
    description = "AWS credentials file profile"
    type = "string"
    default = ""
}

variable "access" {
    description = "AWS access key"
    type = "string"
    default = ""
}

variable "secret" {
    description = "AWS secret key"
    type = "string"
    default = ""
}

variable "region" {
    description = "AWS EC2 region"
    type = "string"
    default = "us-east-1"
}

variable "key_name" {
    description = "AWS keypair name"
    type = "string"
}

variable "vpc_network" {
    description = "Subnet CIDR to use"
    type = "string"
    default = "10.0.0.0/16"
}

variable "ami" {
    description = "AWS ami id to use for web01 instance"
    type = "string"
}

variable "shape" {
    description = "AWS instance shape for web01"
    type = "string"
    default = "t2.micro"
}

output "web01_ip" {
    value = "WEB01 ip: ${aws_instance.web01.public_ip}"
}

resource "aws_vpc" "vpc" {
    cidr_block = "${var.vpc_network}"
    tags {
        Name = "test_web_vpc"
    }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.vpc.id}"
    tags {
        Name = "igw_test_web_vpc"
    }
}

resource "aws_route_table" "main_rt" {
    vpc_id = "${aws_vpc.vpc.id}"
    tags {
        Name = "rt_test_web_vpc"
    }
}

resource "aws_route" "main_default" {
    route_table_id = "${aws_route_table.main_rt.id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
}

resource "aws_subnet" "web_subnet" {
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "${var.vpc_network}"
    map_public_ip_on_launch = true
    tags {
        Name = "web_subnet_test_vpc"
    }
}

resource "aws_route_table_association" "web_main" {
    subnet_id = "${aws_subnet.web_subnet.id}"
    route_table_id = "${aws_route_table.main_rt.id}"
}

resource "aws_security_group" "web_sg" {
    name = "web_sg"
    description = "Security group for web instances"
    vpc_id = "${aws_vpc.vpc.id}"
    ingress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["${var.vpc_network}"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name = "web_sg_test_vpc"
    }
}

resource "aws_instance" "web01" {
    ami = "${var.ami}"
    instance_type = "${var.shape}"
    vpc_security_group_ids = ["${aws_security_group.web_sg.id}"]
    subnet_id = "${aws_subnet.web_subnet.id}"
    key_name = "${var.key_name}"
    root_block_device = {
        delete_on_termination = "true"
    }

    tags {
        Name = "web01-test-vpc"
    }
}
