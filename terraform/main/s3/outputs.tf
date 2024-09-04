output "bucket_name_static" {
  value = aws_s3_bucket.static_artifact_store_bucket.bucket
}

output "bucket_name_lambda" {
  value = aws_s3_bucket.lambda_artifact_store_bucket.bucket
}
