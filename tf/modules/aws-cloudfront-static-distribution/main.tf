locals {
  s3_origin_id = "myS3Origin"
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "Origin Access Identity"
}

data "aws_cloudfront_cache_policy" "example" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_distribution" "distribution" {
  depends_on = [ aws_cloudfront_origin_access_identity.origin_access_identity ]
  origin {
    domain_name = data.aws_s3_bucket.selected.website_endpoint
    origin_id   = data.aws_s3_bucket.selected.website_endpoint

    origin_shield {
      enabled = false
      origin_shield_region = "ap-southeasr-1"
    }
    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    compress               = true
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
    target_origin_id       = data.aws_s3_bucket.selected.website_endpoint
    smooth_streaming       = false
    cache_policy_id = data.aws_cloudfront_cache_policy.example.id
  }

  price_class = "PriceClass_All"
  aliases     = ["www.jjkoh.net", "jjkoh.net"]

  viewer_certificate {
    acm_certificate_arn            = data.aws_acm_certificate.issued.arn
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  enabled = true

  http_version        = "http2"
  default_root_object = var.default_root_object

  logging_config {
    bucket          = var.logging_bucket_name
    include_cookies = false
    prefix          = "logs/"
  }

  is_ipv6_enabled = false

  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "production"
  }
}

data "aws_s3_bucket" "selected" {
  bucket = var.bucket_name
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

data "aws_acm_certificate" "issued" {
  domain   = var.issued_cert_domain_name
  statuses = ["ISSUED"]
  provider = aws.virginia
}