resource "aws_iam_user" "security_admin" {
  name = "security-admin"
}

resource "aws_iam_policy" "read_only" {
  name   = "ReadOnlyAccess"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["s3:Get*", "cloudtrail:Describe*"],
      Resource = "*"
    }]
  })
}
