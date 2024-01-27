variable "bucket_name" {
  description = "Name of the s3 bucket"
  type        = string
}

variable "issued_cert_domain_name" {
  description = "Domain name whose certificate has been issued"
  type        = string
}

variable "default_root_object" {
  description = "Name of the default root object."
  type        = string
}

variable "logging_bucket_name" {
  description = "Name of the logging bucket"
  type        = string
}
