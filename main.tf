provider "aws" {
  profile = "terraform"
  region  = "ap-northeast-1"
}

# ----------------------------------
# VPC
# ----------------------------------
resource "aws_vpc" "sample_vpc" {
  cidr_block                       = "192.168.0.0/20"
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name = "sample-vpc"
  }
}

# ----------------------------------
# Subnet
# ----------------------------------
resource "aws_subnet" "sample_subnet" {
  vpc_id                          = aws_vpc.sample_vpc.id
  cidr_block                      = "192.168.1.0/24"
  assign_ipv6_address_on_creation = "false"
  map_public_ip_on_launch         = "true"
  availability_zone               = "ap-northeast-1a"

  tags = {
    Name = "sample_subnet"
  }
}

# ----------------------------------
# InternetGateway
# ----------------------------------
resource "aws_internet_gateway" "sample_igw" {
  vpc_id = aws_vpc.sample_vpc.id
  tags = {
    Name = "sample_igw"
  }
}

# ----------------------------------
# RouteTable
# ----------------------------------
resource "aws_route_table" "sample_rt" {
  vpc_id = aws_vpc.sample_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sample_igw.id
  }

  tags = {
    Name = "sample_rt"
  }
}

# ----------------------------------
# RouteTableをVPCとSubnetに紐付け
# ----------------------------------
resource "aws_main_route_table_association" "sample_rt_vpc" {
  vpc_id         = aws_vpc.sample_vpc.id
  route_table_id = aws_route_table.sample_rt.id
}

resource "aws_route_table_association" "sample_rt_subet_a" {
  subnet_id      = aws_subnet.sample_subnet.id
  route_table_id = aws_route_table.sample_rt.id
}

# ----------------------------------
# EC2
# ----------------------------------
resource "aws_instance" "sample_ec2" {
  ami                     = "ami-0a3d21ec6281df8cb"
  instance_type           = "t2.micro"
  subnet_id               = aws_subnet.sample_subnet.id
  disable_api_termination = false

  tags = {
    Name = "sample-ec2"
  }
}