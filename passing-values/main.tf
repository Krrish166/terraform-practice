provider "aws" {
  region = "ap-south-1"
}

provider "aws" {
    alias = "use1"
  region = "us-east-1"
}

module "test_ec2" {
  source = "../modules"
  ami = "ami-0ced6a024bb18ff2e" # ami for mumbai
  instance_type = "t2.medium"
  availability_zone = "ap-south-1a"
  subnet_id = "subnet-0f725c1812c1f2682"
  providers = {
    aws=aws
  }
  tags = {
    Name = "dev-instance"
  }

}

module "ec2_dev" {
  source = "../modules"
  ami = "ami-07ff62358b87c7116"  # ami for North Virginia
  instance_type = "t2.micro"
  subnet_id = "subnet-0c35c14affcacc2f2"
  availability_zone = "us-east-1a"
  providers = {
    aws=aws.use1
  }
  tags = {
    Name = "use1-dev-instance"
  }
}