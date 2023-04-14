output "search_api_url" {
    value = aws_api_gateway_deployment.apig_deployment.invoke_url
}

output "bucket_portrait_photos_path" {
    value = "s3://${module.personnel_bucket.s3_bucket_id}/photos/portrait/"
}