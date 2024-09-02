# Create IAM user
resource "aws_iam_user" "user_hari" {
  name = "hari"
}

# Create login profile (set the password)
resource "aws_iam_user_login_profile" "user_hari_profile" {
  user                = aws_iam_user.user_hari.name
  password            = "@123Admin"
  password_reset_required = false
}

# Attach the AdministratorAccess policy (full access to all AWS services)
resource "aws_iam_user_policy_attachment" "user_hari_admin_policy" {
  user       = aws_iam_user.user_hari.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

output "user_name" {
  value = aws_iam_user.user_hari.name
}
│ Error: Value for unconfigurable attribute
│
│   with aws_iam_user_login_profile.user_hari_profile,
│   on iam.tf line 9, in resource "aws_iam_user_login_profile" "user_hari_profile":
│    9:   password            = "@123Admin"
│
│ Can't configure a value for "password": its value will be decided automatically based on the result
│ of applying this configuration.
╵