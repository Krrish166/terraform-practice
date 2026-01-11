resource "aws_instance" "name" {
  ami = "ami-00ca570c1b6d79f36"
  instance_type = "t2.micro"
}

resource "aws_s3_bucket" "name" {
  bucket = "my-unique-bucket-5689"
}

# target resource is used for testing purposes like it's apply only in a specific resource like to call or it destroy
# syntax: terraform apply -target=aws_instance.name
# syntax: terraform destroy -target=aws_s3_bucket.name