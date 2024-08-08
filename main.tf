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

module "s3" {
  source      = "./modules/s3"
  domain_name = var.domain_name
}

module "acm" {
  source          = "./modules/acm"
  domain_name     = var.domain_name

  # Pass the manually created zone ID
  route53_zone_id = "YOUR_ROUTE53_ZONE_ID"
}

module "ec2" {
  source    = "./modules/ec2"
  ami_id    = var.ami_id
  subnet_id = data.aws_subnets.default.ids[0]
}

module "alb" {
  source     = "./modules/alb"
  vpc_id     = data.aws_vpc.default.id
  subnet_ids = data.aws_subnets.default.ids

  # Use manually created ACM certificate for ALB
  cert_arn   = "YOUR_ACM_CERT_ARN_EU_CENTRAL_1"
}

module "asg" {
  source     = "./modules/asg"
  ami_id     = var.ami_id
  subnet_ids = data.aws_subnets.default.ids
}

module "cloudfront" {
  source      = "./modules/cloudfront"
  s3_bucket   = module.s3.bucket_id

  # Use manually created ACM certificate for CloudFront
  cert_arn    = "YOUR_ACM_CERT_ARN_US_EAST_1"
  domain_name = var.domain_name
  oai_id      = module.s3.oai_id
}

module "route53" {
  source         = "./modules/route53"
  domain_name    = var.domain_name
  cf_domain_name = module.cloudfront.cf_domain_name

  # Use the manually created zone ID
  zone_id        = "YOUR_ROUTE53_ZONE_ID"
}
