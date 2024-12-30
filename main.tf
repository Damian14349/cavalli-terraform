provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_acm_certificate" "alb" {
  domain      = var.domain_name
  statuses    = ["ISSUED"]
  most_recent = true
}

data "aws_acm_certificate" "cloudfront" {
  provider    = aws.us-east-1
  domain      = var.domain_name
  statuses    = ["ISSUED"]
  most_recent = true
}

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

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "wordpress-db-subnet-group"
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Name = "WordPress DB Subnet Group"
  }
}

data "aws_security_group" "existing_sg" {
  count = local.use_existing_sg ? 1 : 0
  filter {
    name   = "group-name"
    values = [var.existing_sg_name]
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
  alb_origin_dns = module.alb.dns_name
  cert_arn       = data.aws_acm_certificate.cloudfront.arn
  domain_name    = var.domain_name
  s3_bucket_domain_name = module.s3.bucket_domain_name
}

module "s3" {
  source      = "./modules/s3"
  domain_name = var.domain_name
  cloudfront_oai_arn = module.cloudfront.oai_arn
}

module "rds" {
  source                 = "./modules/rds"
  db_instance_class      = var.db_instance_class
  db_name                = var.db_name
  db_user                = var.db_user
  db_password            = var.db_password
  vpc_security_group_ids = local.use_existing_sg ? [data.aws_security_group.existing_sg[0].id] : [aws_security_group.alb_sg[0].id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
}
