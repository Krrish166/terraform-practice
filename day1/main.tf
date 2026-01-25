# EC2 in Mumbai Region
resource "aws_instance" "name" {
    ami = var.ami
    instance_type = var.instancetype
    tags = {
      Name= "terraform-mumbai-ec2"
    }
  
}

# EC2 in Virginia
resource "aws_instance" "virginia_ec2" {
    provider    = aws.virginia
    ami = var.virginia_ami
    subnet_id = "subnet-00731278fbfcec6a8"
    instance_type = var.virginia_type
    tags = {
        Name = "terraform-virginia"
    }
  
}
