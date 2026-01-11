# ceate security group with multiple inbound rules in the same VPC with one source block
resource "aws_security_group" "my-sg" {
  name        = "my-security-group"
  description = "Allow inbound traffic"
    vpc_id      = aws_vpc.unkown-vpc.id

# create inbound rule for multiple ports
  # how it works: creates multiple ingress rules for each port in the list
   ingress = [
    for port in [22, 80, 443, 8080, 9000, 3000, 8082, 8081] : {
      description      = "inbound rules"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]


    # allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc" "unkown-vpc" {
  cidr_block = "10.0.0.0/16"
}