resource "aws_instance" "name" {
  ami = "ami-00ca570c1b6d79f36"
  instance_type = "t2.nano"
  tags = {
    Name = "LifecycleExample"
  }
  lifecycle {
    create_before_destroy = true   # Ensure new resource is created before old one is destroyed
  }
    # lifecycle {
    #   prevent_destroy = true  # Prevent accidental destruction of the resource
    # }

#   lifecycle {
#     ignore_changes = [ instance_type ]  # Ignore changes to instance_type during updates
#   }
}