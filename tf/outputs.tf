output "root_domain_region" {
  value       = module.root_domain_s3_bucket.region
  description = "Region of the root domain bucket"
}

output "root_domain_bucket_arn" {
  description = "ARN of the root domain bucket"
  value       = module.root_domain_s3_bucket.arn
}

output "root_domain_bucket_name" {
  description = "Name (id) of the root domain bucket"
  value       = module.root_domain_s3_bucket.name
}

output "root_domain_bucket_domain" {
  description = "Domain name of the root domain bucket"
  value       = module.root_domain_s3_bucket.domain
}

output "root_domain_website_endpoint" {
  value       = module.root_domain_s3_bucket.website-endpoint
  description = "Website endpoint of the root domain bucket"
}

output "subdomain_region" {
  value       = module.subdomain_s3_bucket.region
  description = "Region of the subdomain bucket"
}

output "subdomain_bucket_arn" {
  description = "ARN of the subdomain bucket"
  value       = module.subdomain_s3_bucket.arn
}

output "subdomain_bucket_name" {
  description = "Name (id) of the subdomain bucket"
  value       = module.subdomain_s3_bucket.name
}

output "subdomain_bucket_domain" {
  description = "Domain name of the subdomain bucket"
  value       = module.subdomain_s3_bucket.domain
}

output "subdomain_website_endpoint" {
  value       = module.subdomain_s3_bucket.website-endpoint
  description = "Website endpoint of the subdomain bucket"
}

output "root_domain_alias_record_name" {
  value       = module.root_domain_alias_record.route53_record_name
  description = "Name of the root domain alias record."
}

output "subdomain_alias_record_name" {
  value       = module.subdomain_alias_record.route53_record_name
  description = "Name of the subdomain alias record."
}