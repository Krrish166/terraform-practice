
provider "aws" {
  
}
resource "aws_instance" "server" {
  ami                         =  "ami-00ca570c1b6d79f36" #  AMI
  instance_type               = "t2.micro"
  user_data = file("test.sh")
  tags = {
    Name = "UbuntuServer"
  }
}

# user_data = file("test.sh")  -->  to run script during instance launch