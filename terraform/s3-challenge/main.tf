resource "aws_s3_bucket" "my_bucket" {
  bucket = "ade091-bucket"

  tags = {
    Name        = "s3 challenge bucket"
    Environment = "Dev"
  }
}