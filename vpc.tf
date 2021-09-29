# Create a new VPC using the 10.0.0.0/16 CIDR block
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "main"
  }
}

# Create a new internet gateway for the VPC
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "main"
  }
}

# Manage the default route table of the VPC and
# add a route for 0.0.0.0/0 that sends traffic
# to the managed internet gateway.
resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.main.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
      tags = {
        "Name" = "main"
    }
}

# Assosiate public subnet with public route table
resource "aws_route_table_association" "public_subnet_route_table" {
subnet_id = aws_subnet.main.id
route_table_id = aws_default_route_table.main.id
}