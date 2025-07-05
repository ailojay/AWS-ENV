resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 14
  require_lowercase_characters  = true
  require_uppercase_characters  = true
  require_numbers                = true
  require_symbols                = true
  allow_users_to_change_password = true
  hard_expiry                    = true
  max_password_age               = 90
  password_reuse_prevention      = 5
}

resource "aws_iam_policy" "require_mfa" {
  name        = "DenyAllExceptWithMFA"
  path        = "/"
  description = "Deny all IAM actions unless MFA is present"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "BlockMostAccessUnlessMFA",
        "Effect": "Deny",
        "Action": "*",
        "Resource": "*",
        "Condition": {
          "BoolIfExists": {
            "aws:MultiFactorAuthPresent": "false"
          }
        }
      }
    ]
  })
}

resource "aws_iam_group" "mfa_enforced" {
  name = "MFAEnforcedUsers"
}

resource "aws_iam_group_policy_attachment" "mfa_attachment" {
  group      = aws_iam_group.mfa_enforced.name
  policy_arn = aws_iam_policy.require_mfa.arn
}


resource "aws_iam_user_group_membership" "enforce_mfa_membership" {
  user = "awscliuser"  # Replace with any IAM user you want to enforce MFA for
  groups = [
    aws_iam_group.mfa_enforced.name
  ]
}


resource "aws_iam_account_password_policy" "secure_password_policy" {
  minimum_password_length         = 14
  require_uppercase_characters   = true
  require_lowercase_characters   = true
  require_numbers                 = true
  require_symbols                 = true
  allow_users_to_change_password = true
  hard_expiry                     = false
  max_password_age                = 90
  password_reuse_prevention       = 5
}
