resource "aws_instance" "wordpress" {
  ami           = var.ami_id
  instance_type = "t3.micro"
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = "WordPressInstance"
  }
}

resource "aws_security_group" "sg" {
  name        = "allow_alb"
  description = "Allow HTTP and HTTPS from ALB"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
