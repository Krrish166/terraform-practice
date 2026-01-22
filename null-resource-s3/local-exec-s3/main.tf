resource "aws_s3_bucket" "name" {
  bucket = "mybucketnijaway"
}

resource "null_resource" "upload" {
    depends_on = [ aws_s3_bucket.name ]
    provisioner "local-exec" {
    command = "aws s3 cp file.txt s3://${aws_s3_bucket.name.bucket}/file.txt" # it means copy file.txt to s3 bucket
  }

  # This trigger ensures the local-exec runs on every apply
  triggers = {
    always_run = timestamp()
  }
}