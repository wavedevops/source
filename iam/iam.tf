provider "aws" {
  region = "us-east-1"  # Set your desired AWS region
}

# Retrieve the password from AWS Systems Manager Parameter Store
data "aws_ssm_parameter" "hari_password" {
  name            = "/myapp/hari/password"  # Replace with your actual parameter name
  with_decryption = true                    # Decrypts the SecureString value
}

# Create IAM user
resource "aws_iam_user" "user_hari" {
  name = "hari"
}

# Create login profile (set the password)
resource "aws_iam_user_login_profile" "user_hari_profile" {
  user                = aws_iam_user.user_hari.name
  password            = data.aws_ssm_parameter.hari_password.value
  password_reset_required = false
  pgp_key = ""
}

# Attach the AdministratorAccess policy (full access to all AWS services)
resource "aws_iam_user_policy_attachment" "user_hari_admin_policy" {
  user       = aws_iam_user.user_hari.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

output "user_name" {
  value = aws_iam_user.user_hari.name
}
