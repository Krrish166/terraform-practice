resource "aws_instance" "name" {
  ami = "ami-0ced6a024bb18ff2e"
  instance_type = "t2.micro"
  tags = {
    Name="tofu-migrate-state"
  }
}