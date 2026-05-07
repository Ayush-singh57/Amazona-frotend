output "final_frontend_url" {
  value       = module.frontend_cdn.cloudfront_url
  description = "Click this link to see your live React app!"
}

output "upload_to_this_bucket" {
  value       = module.frontend_cdn.s3_bucket_name
  description = "Drag your 'build' folder contents into this S3 bucket."
}