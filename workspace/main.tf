provider "aws" {
  
}
resource "aws_instance" "server" {
  ami                         = "ami-0ced6a024bb18ff2e" # Ubuntu AMI
  instance_type               = "t2.micro"

  tags = {
    Name = "UbuntuServer"
  }
}

# tf workspace select  to switch workspace
# tf workspace new  to create new workspace
# tf workspace show to show current workspace