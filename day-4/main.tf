resource "aws_instance" "name" {
    instance_type = "t2.medium"
    ami = "ami-00ca570c1b6d79f36"
    tags = {
      Name="state-lock"
    }
}


