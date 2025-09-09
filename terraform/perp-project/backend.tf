terraform {
  backend "s3" {
    bucket         = "perp-project-tfstate"      # Your S3 state bucket
    key            = "perp-project/main.tfstate" # Path inside the bucket for this project
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"           # Lock table for concurrency
    encrypt        = true
  }
}
