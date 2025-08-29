# Create an IAM user with access key
module "s3_reader_user" {
  source = "../modules/iam_user"

  username         = "s3-reader-user"
  create_iam_user  = true
  create_access_key = true
}

# Create another user without access key
module "backup_user" {
  source = "../modules/iam_user"

  username        = "backup-user"
  create_iam_user = true
  # create_access_key defaults to false
}