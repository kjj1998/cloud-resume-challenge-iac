variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "root_domain_bucket_tags" {
  description = "tags to set for the s3 root domain bucket"
  type        = map(string)
  default = {
    Name        = "My root domain bucket"
    Environment = "Dev"
  }
}

variable "subdomaindomain_bucket_tags" {
  description = "tags to set for the s3 subdomain bucket"
  type        = map(string)
  default = {
    Name        = "My subdomain bucket"
    Environment = "Dev"
  }
}

variable "enable_force_destroy" {
  description = "Force destroy status for s3 bucket"
  type        = bool
  default     = true
}

variable "bucket_object_ownership" {
  description = "Bucket object ownership scheme"
  type        = string
  default     = "BucketOwnerEnforced"
}

variable "bucket_sse_algorithm" {
  description = "The encryption algorithm used for bucket server side encryption"
  type        = string
  default     = "AES256"
}