resource "aws_iam_policy" "full_access_policy" {
  name        = "Full-Access-Policy"
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
