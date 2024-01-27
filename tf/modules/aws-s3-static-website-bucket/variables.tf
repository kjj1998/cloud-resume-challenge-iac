# Input variable definitions

variable "bucket_name" {
  description = "Name of the s3 bucket. Must be unique."
  type        = string
}

variable "tags" {
  description = "Tags to set on the bucket."
  type        = map(string)
  default     = {}
}

variable "s3_bucket_object_ownership" {
  description = "Bucket object ownership scheme"
  type        = string
  default     = "BucketOwnerEnforced"
}

variable "s3_bucket_sse_algorithm" {
  description = "The encryption algorithm used for bucket server side encryption"
  type        = string
  default     = "AES256"
}

variable "s3_enable_bucket_policy" {
  description = "To control whether the bucket policy gets added."
  type = bool
}

variable "s3_block_public_access" {
  description = "To control whether public access is blocked."
  type = bool
}

variable "s3_target_bucket_for_logging" {
  description = "To identify the bucket where logs will be stored."
  type = string
  default = ""
}

variable "s3_enable_logging" {
  description = "To control whether to enable logging for this bucket."
  type = bool
  default = false
}

variable "s3_website_redirect" {
  description = "To control whether the s3 bucket website will be redirected."
  type = bool
  default = false
}

variable "s3_redirect_requests_host" {
  description = "Name of the host where requests are redirected."
  type = string
  default = ""
}

variable "enable_static_website_hosting" {
  description = "To enable static website hosting"
  type = bool
  default = false
}