provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

# Data source to fetch default VPC
data "aws_vpc" "default" {
  default = true
}

# Data source to fetch default subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Fetch existing ACM certificates
data "aws_acm_certificate" "alb" {
  domain   = var.domain_name
  statuses = ["ISSUED"]
  most_recent = true
}

data "aws_acm_certificate" "cloudfront" {
  provider = aws.us-east-1
  domain   = var.domain_name
  statuses = ["ISSUED"]
  most_recent = true
}

# Declare whether to use existing security group
locals {
  use_existing_sg = var.use_existing_sg
}

resource "aws_security_group" "alb_sg" {
  count       = local.use_existing_sg ? 0 : 1
  name        = "allow_http_https_terraform"
  description = "Allow HTTP and HTTPS traffic to ALB"
  vpc_id      = data.aws_vpc.default.id

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

data "aws_security_group" "existing_sg" {
  count = local.use_existing_sg ? 1 : 0
  filter {
    name   = "group-name"
    values = [var.existing_sg_name] # Make sure this variable is set if using existing SG
  }
  vpc_id = data.aws_vpc.default.id
}

module "alb" {
  source     = "./modules/alb"
  vpc_id     = data.aws_vpc.default.id
  subnet_ids = data.aws_subnets.default.ids
  cert_arn   = data.aws_acm_certificate.alb.arn
  sg_id      = local.use_existing_sg ? data.aws_security_group.existing_sg[0].id : aws_security_group.alb_sg[0].id
}

module "asg" {
  source     = "./modules/asg"
  ami_id     = var.ami_id
  subnet_ids = data.aws_subnets.default.ids
  sg_id      = local.use_existing_sg ? data.aws_security_group.existing_sg[0].id : aws_security_group.alb_sg[0].id
}

module "cloudfront" {
  source         = "./modules/cloudfront"
  alb_origin_dns = module.alb.dns_name  # ALB DNS as primary origin
  cert_arn       = data.aws_acm_certificate.cloudfront.arn
  domain_name    = var.domain_name
}

module "s3" {
  source      = "./modules/s3"
  domain_name = var.domain_name
}
