resource "aws_instance" "name" {
  ami = "ami-05af849cfc4b528fd"
  instance_type = "t2.micro"
  tags = {
    Name= "dev"
  }
  provider = aws.north-california
  
}

resource "aws_s3_bucket" "name" {
  bucket = "myhellobucke5768"
}