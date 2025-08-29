# Conditionally create IAM user
resource "aws_iam_user" "this" {
  count = var.create_iam_user ? 1 : 0

  name = var.username
  path = var.path

  tags = {
    ManagedBy = "Terraform"
  }
}

# Conditionally create access key
resource "aws_iam_access_key" "this" {
  count = var.create_access_key ? 1 : 0
  user  = var.create_iam_user ? aws_iam_user.this[0].name : var.username
}

# IAM policy allowing S3 read-only access
resource "aws_iam_user_policy" "s3_readonly" {
  count = var.create_iam_user ? 1 : 0

  name = "S3ReadOnlyAccess"
  user = aws_iam_user.this[0].name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "custom" {
  count = var.create_iam_user ? length(var.custom_policies) : 0

  user       = aws_iam_user.this[0].name
  policy_arn = var.custom_policies[count.index]
}