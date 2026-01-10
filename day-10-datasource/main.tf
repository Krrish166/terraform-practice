# fetch the latest Amazon Linux 2023 AMI by filtering on name and state
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.10.20260105.0-kernel-6.1-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}
# fetch existing EC2 instance by its ID
data "aws_instance" "existing" {
  instance_id = "i-0c541e996af88bbe2"
}

# fetch subnet by its Name tag
data "aws_subnet" "name" {    
  filter {
    name   = "tag:Name"     
    values = ["my-subnet"]
  }

}
# fetch VPC by its Name tag
data "aws_vpc" "name" {
   filter {
    name   = "tag:Name"     
    values = ["my-vpc"]
  }
}

# note:
# data source is used to fetch information about existing resources in your AWS account without creating new ones.
# resouce block is used to create and manage new resources in your AWS account.