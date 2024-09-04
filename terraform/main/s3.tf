module "s3" {
  source                     = "./s3"
  artifact_store_bucket_name = var.artifact_store_bucket
}
