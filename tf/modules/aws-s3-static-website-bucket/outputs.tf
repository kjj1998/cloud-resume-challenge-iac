output "arn" {
  description = "ARN of the bucket"
  value       = aws_s3_bucket.s3_bucket.arn
}

output "name" {
  description = "Name (id) of the bucket"
  value       = aws_s3_bucket.s3_bucket.id
}

output "domain" {
  description = "Domain name of the bucket"
  value       = aws_s3_bucket_website_configuration.s3_bucket_website_configuration.website_domain
}

output "region" {
    description = "Region of the bucket"
    value = aws_s3_bucket.s3_bucket.region
}

output "website-endpoint" {
    description = "Website endpoint of the bucket"
    value = aws_s3_bucket_website_configuration.s3_bucket_website_configuration.website_endpoint
}