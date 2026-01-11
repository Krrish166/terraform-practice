resource "aws_instance" "name" {
  ami = local.ami
  instance_type = local.instance_type
  region = local.region
  tags = {
    Name=local.app_name
  }
}

# Terraform locals are used to define reusable, computed values within a configuration to keep code clean and DRY.