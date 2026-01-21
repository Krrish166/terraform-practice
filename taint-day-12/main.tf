
provider "aws" {
  
}
resource "aws_instance" "server" {
  ami                         =  "ami-00ca570c1b6d79f36" #  AMI
  instance_type               = "t2.micro"

  tags = {
    Name = "UbuntuServer"
  }
}

# taint is used to mark a resource for recreation on the next apply and it's used after created a resource
# syntax: terraform taint aws_instance.server