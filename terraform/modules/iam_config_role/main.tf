data "aws_iam_policy_document" "config_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "config_role" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.config_assume_role.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "config_policy" {
  role       = aws_iam_role.config_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}

resource "aws_iam_role_policy_attachment" "config_s3_policy" {
  role       = aws_iam_role.config_role.name
  policy_arn = aws_iam_policy.config_s3.arn
}

resource "aws_iam_policy" "config_s3" {
  name        = "${var.role_name}-s3-access"
  description = "Policy for AWS Config to write to S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl"
        ]
        Effect   = "Allow"
        Resource = "${var.s3_bucket_arn}/*"
      },
      {
        Action = [
          "s3:GetBucketAcl"
        ]
        Effect   = "Allow"
        Resource = var.s3_bucket_arn
      }
    ]
  })
}