resource "aws_s3_bucket" "name" {
  bucket = "dsfdffgggdt"
}

# use of import command: it is used to import existing resources into terraform state which are created outside terraform.
# terraform import aws_s3_bucket.name dsfdffgggdt

resource "aws_instance" "name" {
  ami = "ami-00ca570c1b6d79f36"
  instance_type = "t3.medium"
}

# command to import existing aws instance into terraform state

resource "aws_vpc" "name" {
    cidr_block = "172.31.0.0/16"
}
# command to import existing aws vpc into terraform state
# terraform import aws_vpc.name vpc-0bb1c1f2example