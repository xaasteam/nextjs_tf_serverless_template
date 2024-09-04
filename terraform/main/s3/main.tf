resource "aws_s3_bucket" "static_artifact_store_bucket" {
  bucket = join("-", [var.artifact_store_bucket_name, "static"]) 
}
resource "aws_s3_bucket" "lambda_artifact_store_bucket" {
  bucket = join("-", [var.artifact_store_bucket_name, "lambda"]) 
}

resource "aws_s3_object" "static_unzip" {
  bucket = aws_s3_bucket.static_artifact_store_bucket.bucket
  key    = "static/"
  source = "${path.module}/../../static.zip"
  etag   = filemd5("${path.module}/../../static.zip")
}

resource "aws_s3_object" "lambda_unzip" {
  bucket = aws_s3_bucket.lambda_artifact_store_bucket.bucket
  key    = "lambda/"
  source = "${path.module}/../../lambda.zip"
  etag   = filemd5("${path.module}/../../lambda.zip")
}