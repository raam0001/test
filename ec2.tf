provider "aws" {
  region     = "us-west-2"
  access_key = "AKIA3JZJM6GXTP4IJGZF"
  secret_key = "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"
}
resource "aws_s3_bucket" "b" {
  bucket = "ram010101021"
  acl    = "private"

  versioning {
    enabled = true
  }
}
resource "aws_vpc" "Test_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "VPC"
  }
}

resource "aws_subnet" "Test_Subnet" {
  vpc_id            = aws_vpc.Test_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "TestAZ1"
  }
}

resource "aws_network_interface" "foo" {
  subnet_id   = aws_subnet.Test_Subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "NIT"
  }
}

resource "aws_instance" "foo" {
  ami           = "ami-005e54dee72cc1d00" # us-west-2
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.foo.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
}