# # Create IAM user
# resource "aws_iam_user" "user_hari" {
#   name = "hari"
# }
#
# # Create login profile (set the password)
# # resource "aws_iam_user_login_profile" "user_hari_profile" {
# #   user                = aws_iam_user.user_hari.name
# #   password            = "@123Admin"
# #   password_reset_required = false
# # }
#
# # Attach the AdministratorAccess policy (full access to all AWS services)
# resource "aws_iam_user_policy_attachment" "user_hari_admin_policy" {
#   user       = aws_iam_user.user_hari.name
#   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
# }
#
# output "user_name" {
#   value = aws_iam_user.user_hari.name
# }


resource "aws_iam_policy" "full_access_policy" {
  name        = "FullAccessPolicy"
  description = "A policy that grants full access to all resources."
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "*"
        Resource = "*"
      }
    ]
  })
}

output "policy_arn" {
  value = aws_iam_policy.full_access_policy.arn
}
