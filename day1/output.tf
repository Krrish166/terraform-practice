output "publicip" {
  value = aws_instance.name.public_ip
}

output "privatip" {
  value = aws_instance.name.private_ip

}

output "az" {
  value = aws_instance.name.availability_zone

}

output "virginia_public_ip" {
  value = aws_instance.virginia_ec2.public_ip
}

output "virginia_private_ip" {
  value = aws_instance.virginia_ec2.private_ip
}