variable "route53_zone_name" {
    description = "Name of the route53 zone."
    type = string
}

variable "route53_record_type" {
    description = "Type of the route53 record."
    type = string
    default = "A"
}

variable "s3_bucket_name" {
    description = "Name of the s3 bucket for route53 record to route towards."
    type = string
}

variable "subdomain_alias_record_status" {
    description = "Boolean to decide whether this alias record is for the subdomain"
    type = bool
    default = false
}

variable "cloudfront_distribution_id" {
    description = "The cloudfront distribution id."
    type = string
}