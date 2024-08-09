resource "aws_instance" "wordpress" {
  ami           = var.ami_id
  instance_type = "t3.micro"
  subnet_id     = var.subnet_id

  tags = {
    Name = "WordPressInstance"
  }
}
