resource "aws_instance" "name" {
  ami = var.ami
  instance_type = var.instancetype
  tags = {
    Name = "qa"
  }
  
}

resource "aws_s3_bucket" "bijaya" {
  bucket = "mydjfkdkdfkdfkasdk"
}

resource "aws_s3_bucket_versioning" "bijaya" {
  bucket = aws_s3_bucket.bijaya.id
  versioning_configuration {
    status = "Suspended"
  }
}