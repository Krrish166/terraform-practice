output "ami_id" {
  value = data.aws_ami.al2023.id
  
}

output "instance_id" {
  value = data.aws_instance.existing.id
}

output "subnet_id" {
  value = data.aws_subnet.name.id
}

output "aws_vpc" {
  value = data.aws_vpc.name.id
}