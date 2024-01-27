# S3 bucket
resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name

  tags = var.tags
}

# S3 bucket public access
resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = var.s3_block_public_access
  block_public_policy     = var.s3_block_public_access
  ignore_public_acls      = var.s3_block_public_access
  restrict_public_buckets = var.s3_block_public_access
}

# S3 bucket website configuration
resource "aws_s3_bucket_website_configuration" "s3_bucket_website_configuration" {
  bucket = aws_s3_bucket.s3_bucket.id

  dynamic "redirect_all_requests_to" {
    for_each = var.s3_website_redirect ? [1] : []
    content {
      host_name = var.s3_redirect_requests_host
      protocol = "http"
    }
  }
  
  dynamic "index_document" {
    for_each = var.s3_website_redirect ? [] : [1]
    content {
      suffix = "resume.html"
    }
  }

  dynamic "error_document" {
    for_each = var.s3_website_redirect ? [] : [1]
    content {
      key = "error.html"
    }
  }
}

# S3 bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "s3_bucket_ownership_controls" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    object_ownership = var.s3_bucket_object_ownership
  }
}

# S3 bucket server side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_server_side_encryption_configuration" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.s3_bucket_sse_algorithm
    }
  }
}

# S3 bucket policy
resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  count = var.s3_enable_bucket_policy ? 1 : 0 
  bucket = aws_s3_bucket.s3_bucket.id
  policy = data.aws_iam_policy_document.s3_iam_policy_document.json
  depends_on = [ aws_s3_bucket_public_access_block.s3_bucket_public_access_block ]
}

# IAM policy for reading S3 bucket
data "aws_iam_policy_document" "s3_iam_policy_document" {
  statement {
    sid       = "PublicReadGetObject"
    effect    = "Allow"
    resources = ["${aws_s3_bucket.s3_bucket.arn}/*"]
    actions   = ["s3:GetObject"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

# S3 bucket logging
resource "aws_s3_bucket_logging" "s3_bucket_logging" {
  count = var.s3_enable_logging ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.id

  target_bucket = var.s3_target_bucket_for_logging
  target_prefix = "logs/"
  target_object_key_format {
    simple_prefix {}
  }
}