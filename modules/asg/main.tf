resource "aws_security_group" "sg" {
  name        = "allow_http_https"
  description = "Allow HTTP and HTTPS traffic to instances"

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

resource "aws_launch_configuration" "wordpress_lc" {
  name          = "wordpress-lc"
  image_id      = var.ami_id
  instance_type = "t3.micro"
  security_groups = [aws_security_group.sg.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "wordpress_asg" {
  desired_capacity     = 1
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = var.subnet_ids

  launch_configuration = aws_launch_configuration.wordpress_lc.id

  health_check_type     = "EC2"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "WordPressASG"
    propagate_at_launch = true
  }
}
