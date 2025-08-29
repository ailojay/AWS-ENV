module "website_assets" {
  source              = "../modules/s3_bucket"
  bucket_name         = var.bucket_name
  environment         = var.environment
  enable_versioning   = var.enable_versioning
  block_public_access = var.block_public_access
}
