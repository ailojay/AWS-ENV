provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "secure_user" {
  name = "secure-user"
  force_destroy = true
  tags = {
    "Environment" = "dev"
  }
}

resource "aws_iam_group" "secure_group" {
  name = "secure-group"
}

resource "aws_iam_user_group_membership" "user_group_membership" {
  user = aws_iam_user.secure_user.name
  groups = [aws_iam_group.secure_group.name]
}


resource "aws_iam_policy" "mfa_enforce_policy" {
  name        = "Enforce-MFA-Policy"
  path        = "/"
  description = "Deny all actions unless MFA is used"
  policy      = file("${path.module}/mfa_policy.json")
}

resource "aws_iam_group_policy_attachment" "group_attach" {
  group      = aws_iam_group.secure_group.name
  policy_arn = aws_iam_policy.mfa_enforce_policy.arn
}


resource "aws_iam_group" "admin_group" {
  name = "admin-group"
}

resource "aws_iam_group_policy_attachment" "admin_attach" {
  group      = aws_iam_group.admin_group.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_group" "readonly_group" {
  name = "readonly-group"
}

resource "aws_iam_group_policy_attachment" "readonly_attach" {
  group      = aws_iam_group.readonly_group.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}



resource "aws_iam_user" "dev_admin" {
  name = "dev_admin_user"
  force_destroy = true
}

resource "aws_iam_user_group_membership" "dev_admin_membership" {
  user = aws_iam_user.dev_admin.name
  groups = [
    aws_iam_group.admin_group.name
  ]
}

resource "aws_iam_user" "audit_user" {
  name = "audit_user"
  force_destroy = true
}

resource "aws_iam_user_group_membership" "audit_user_membership" {
  user = aws_iam_user.audit_user.name
  groups = [
    aws_iam_group.readonly_group.name
  ]
}
