resource "aws_iam_role" "ec2_role" {
  name = "ec2-s3-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
            Service = "ec2.amazonaws.com"
            }
        }
        ]
    })

}

resource "aws_iam_role_policy" "s3_policy" {
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["s3:PutObject", "s3:GetObject"]
        Resource = "arn:aws:s3:::dsfdffgggdt/*"
      },
      {
        Effect = "Allow"
        Action = ["s3:ListBucket"]
        Resource = "arn:aws:s3:::dsfdffgggdt"
      }
    ]
  })
}


resource "aws_iam_instance_profile" "profile" {
  role = aws_iam_role.ec2_role.name
}



resource "aws_key_pair" "name" {
  key_name = "my-key"
  public_key = file("~/.ssh/id_ed25519.pub")

}

resource "aws_instance" "name" {
  ami = "ami-0ced6a024bb18ff2e"
  instance_type = "t2.micro"
  tags = {
    Name= "remote-exec"
  }
  iam_instance_profile = aws_iam_instance_profile.profile.name
  key_name = aws_key_pair.name.key_name
}

resource "aws_s3_bucket" "name" {
  bucket = "dsfdffgggdt" # Change to a unique name
  
}


resource "null_resource" "name" {
  depends_on = [ aws_instance.name,aws_s3_bucket.name ]

  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("~/.ssh/id_ed25519")
    host = aws_instance.name.public_ip
  }
    # First, use the file provisioner to upload a file to the EC2 instance
   provisioner "file" {
    source      = "file.txt"
    destination = "/home/ec2-user/file.txt"
  }

   # now use remote-exec to run aws s3 cp command to upload the file to S3
  provisioner "remote-exec" {
    inline = [ 
      "aws s3 cp /home/ec2-user/file.txt s3://${aws_s3_bucket.name.bucket}/file.txt"
     ]
  }

  triggers = {
    always_run = timestamp() # trigger every time apply
  }
}