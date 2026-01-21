resource "aws_key_pair" "example" {
  key_name   = "task"
  public_key = file("~/.ssh/id_ed25519.pub")
}


resource "aws_instance" "name" {
  ami = "ami-0ced6a024bb18ff2e"
  instance_type = "t2.micro"
  key_name = "task"
  tags = {
    Name="remote-null"
  }
}

resource "null_resource" "remote-sql-exec" {
  depends_on = [ aws_instance.name,aws,aws_db_instance.mysql_rds ]

   connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/id_ed25519")   # Replace with your PEM file path
    host        = aws_instance.name.public_ip
  }
    provisioner "remote-exec" {
    inline = [
      "mysql -h ${aws_db_instance.mysql_rds.address} -u ${jsondecode(aws_secretsmanager_secret_version.rds_secret_value.secret_string)["username"]} -p${jsondecode(aws_secretsmanager_secret_version.rds_secret_value.secret_string)["password"]} < /tmp/init.sql"
    ]
  }

  
  triggers = {
    always_run = timestamp() #trigger every time apply 
  }
}