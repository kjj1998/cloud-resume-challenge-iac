terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.33.0"
    }
  }

  backend "s3" {
    key            = "global/s3/terraform.tfstate"
    bucket         = "terraform-remote-state-3242398"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-remote-locks-3242398"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

module "remote_state" {
  source = "./global/aws-s3-remote-state"
}

module "root_domain_s3_bucket" {
  source = "./modules/aws-s3-static-website-bucket"

  bucket_name                  = "jjkoh.net"
  s3_enable_bucket_policy      = true
  s3_block_public_access       = false
  s3_enable_logging            = true
  s3_target_bucket_for_logging = module.logging_s3_bucket.name

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "My root domain bucket"
  }

  depends_on = [module.logging_s3_bucket]
}

module "subdomain_s3_bucket" {
  source = "./modules/aws-s3-static-website-bucket"

  bucket_name               = "www.jjkoh.net"
  s3_enable_bucket_policy   = false
  s3_block_public_access    = true
  s3_website_redirect       = true
  s3_redirect_requests_host = module.root_domain_s3_bucket.name

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "My subdomain bucket"
  }
}

module "logging_s3_bucket" {
  source = "./modules/aws-s3-static-website-bucket"

  bucket_name                = "logs.jjkoh.net"
  s3_enable_bucket_policy    = false
  s3_block_public_access     = true
  s3_bucket_object_ownership = "BucketOwnerPreferred"


  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "My logging bucket"
  }
}

module "root_domain_alias_record" {
  source = "./modules/aws-route53-static-hosting-record"

  s3_bucket_name             = module.root_domain_s3_bucket.name
  route53_zone_name          = "jjkoh.net"
  cloudfront_distribution_id = module.static_cloudfront_distribution.id
}

module "subdomain_alias_record" {
  source = "./modules/aws-route53-static-hosting-record"

  subdomain_alias_record_status = true
  s3_bucket_name                = module.subdomain_s3_bucket.name
  route53_zone_name             = "jjkoh.net"
  cloudfront_distribution_id    = module.static_cloudfront_distribution.id

  depends_on = [module.root_domain_alias_record]
}

module "static_cloudfront_distribution" {
  source = "./modules/aws-cloudfront-static-distribution"

  issued_cert_domain_name = "jjkoh.net"
  logging_bucket_name     = "logs.jjkoh.net.s3.amazonaws.com"
  bucket_name             = module.root_domain_s3_bucket.name
  default_root_object     = "resume.html"
}

module "aws-dynamodb-counter" {
  source = "./modules/aws-dynamodb-counter"

  table_name             = "Counter2"
  hash_key               = "CounterID"
  hash_key_type          = "S"
  autoscale_max_capacity = 10
  autoscale_min_capacity = 1
  target_utilization     = 70
  read_capacity          = 1
  write_capacity         = 1
}

module "aws-apigateway-counter-api" {
  source       = "./modules/aws-apigateway-counter-api"
  api_name     = "update-view-count-api-2"
  api_protocol = "HTTP"
}

resource "aws_s3_object" "logs_folder" {
  bucket = module.logging_s3_bucket.name
  key    = "logs/"

  depends_on = [module.logging_s3_bucket]
}

resource "aws_s3_object" "index" {
  bucket       = module.root_domain_s3_bucket.name
  key          = "resume.html"
  source       = "../src/resume.html"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket       = module.root_domain_s3_bucket.name
  key          = "error.html"
  source       = "../src/error.html"
  content_type = "text/html"
}
