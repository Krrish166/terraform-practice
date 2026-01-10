# creating VPC 
resource "aws_vpc" "bijaya" {
  cidr_block ="10.0.0.0/16"
  tags = {
    Name = "my_vpc"
  }
}

# creating Subnets
resource "aws_subnet" "name" {
  vpc_id = aws_vpc.bijaya.id
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "pub_subnet-1"
  }
  availability_zone = "ap-south-1a"
}

resource "aws_subnet" "name2" {
  vpc_id = aws_vpc.bijaya.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "pvt_subnet-2"
  }
  availability_zone = "ap-south-1b"
}

# creating Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.bijaya.id
    tags = {
        Name = "my_igw"
    }
}

# creating Route Table
resource "aws_route_table" "pub-rt" {
    vpc_id = aws_vpc.bijaya.id
    tags = {
        Name = "my_route_table"
    }
    route {
        cidr_block="0.0.0.0/0"
        gateway_id=aws_internet_gateway.igw.id
        
    }
}

# associating Route Table with Subnet
resource "aws_route_table_association" "pub-rt-assoc" {
  subnet_id = aws_subnet.name.id
  route_table_id = aws_route_table.pub-rt.id
}

# creating elastic IP
resource "aws_eip" "nat-eip" {
  domain = "vpc"

}

# creating nat gateway
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id = aws_subnet.name.id
  tags = {
    Name = "my_nat_gateway"
  }
}

# creating Route Table for private subnet
resource "aws_route_table" "pvt-rt" {
  vpc_id = aws_vpc.bijaya.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }
  tags = {
    Name= "pvt-rt"
  }
}

# associating private route table with private subnet
resource "aws_route_table_association" "pvt-rt-assoc" {
  subnet_id = aws_subnet.name2.id
  route_table_id = aws_route_table.pvt-rt.id
}

# creating security group
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.bijaya.id

  ingress {
    description = "TLS from ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from ssh"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

# creating EC2 instance in public subnet
resource "aws_instance" "web" {
  ami           = "ami-00ca570c1b6d79f36"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.name.id
  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  tags = {
    Name = "MyCustomNetworkInstance"
  }
  
}
